//
//  HomeViewModel.swift
//  eurosport
//
//  Created by Thanh on 02/12/2022.
//

import UIKit
import Combine

protocol HomeViewModel {
    func fetchHome()
    var currentState: AnyPublisher<HomeState, Never> { get }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}

indirect enum HomeState: Equatable {
    case idle
    case loading(previousState: HomeState?)
    case error(Error)
    case loaded([HomeArticleViewModel])
    
    var values: [HomeArticleViewModel] {
        switch self {
        case .idle, .error:
            return []
        case .loading(let previousState):
            return previousState?.values ?? []
        case .loaded(let array):
            return array
        }
    }
    
    static func == (lhs: HomeState, rhs: HomeState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading(let previousState), .loaded(let values)):
            return previousState?.values == values
        case (.loaded(let values1), .loaded(let values2)):
            return values1 == values2
        default:
            return false
        }
    }
}

enum HomeArticleViewModel: Equatable {
    case story(Story)
    case video(Video)
    
    static func == (lhs: HomeArticleViewModel, rhs: HomeArticleViewModel) -> Bool {
        switch (lhs, rhs) {
        case (.story(let story1), .story(let story2)):
            return story1 == story2
        case (.video(let video1), .video(let video2)):
            return video1 == video2
        default:
            return false
        }
    }
    
    func toCellViewModel(usingFormatter formatter: RelativeDateTimeFormatter) -> HomeTableViewCellViewModel {
        switch self {
        case .story(let story):
            let date = Date(timeIntervalSince1970: story.date)
            let relativeDate = formatter.localizedString(for: date, relativeTo: Date())
            
            return HomeTableViewCellViewModel(
                title: story.title,
                subtitle: L10n.homeCellSubtitle(story.author, relativeDate),
                thumbnailURL: story.image,
                type: story.articleType,
                category: story.sport.name
            )

        case .video(let video):
            return HomeTableViewCellViewModel(
                title: video.title,
                subtitle: L10n.homeVideoViews(video.views),
                thumbnailURL: video.thumbnail,
                type: video.articleType,
                category: video.sport.name
            )
        }
    }
}

final class LiveHomeViewModel: NSObject, HomeViewModel {
    
    private var coordinator: RootCoordinator?
    private let repository: HomeRepository
    private lazy var formatter = {
        let relativeFormatter = RelativeDateTimeFormatter()
        relativeFormatter.unitsStyle = .full
        return relativeFormatter
    }()
    
    // MARK: - Combine properties
    private var cancellables = Set<AnyCancellable>()
    private var subjectCurrentState = CurrentValueSubject<HomeState, Never>(.idle)
    
    var currentState: AnyPublisher<HomeState, Never> {
        subjectCurrentState
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    init(
        coordinator: RootCoordinator,
        homeRepository: HomeRepository
    ) {
        self.coordinator = coordinator
        self.repository = homeRepository
    }
    
    func fetchHome() {
        subjectCurrentState.send(.loading(previousState: subjectCurrentState.value))
        
        repository.getHomeArticles()
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.subjectCurrentState.send(.error(error))
                case .finished:
                    break
                }
            } receiveValue: { [weak self] dtoHome in
                let viewModels = self?.dtoToViewModels(dto: dtoHome) ?? []
                self?.subjectCurrentState.send(.loaded(viewModels))
            }
            .store(in: &cancellables)

    }
    
    func dtoToViewModels(dto: DTOHome) -> [HomeArticleViewModel] {
        var viewModels = [HomeArticleViewModel]()
        
        let stories = dto
            .stories
            .sorted(by: { $0.date < $1.date })
            .map { HomeArticleViewModel.story($0) }
        
        let videos = dto
            .videos
            .sorted(by: { $0.date < $1.date })
            .map { HomeArticleViewModel.video($0) }
        
        let maxCount = max(videos.count, stories.count)
        for i in 0..<maxCount {
            if i < stories.count {
                viewModels.append(stories[i])
            }
            if i < videos.count {
                viewModels.append(videos[i])
            }
        }
        
        return viewModels
    }
}

extension LiveHomeViewModel {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjectCurrentState.value.values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: HomeTableViewCell.self, at: indexPath)
        let viewModel = subjectCurrentState.value.values[indexPath.row].toCellViewModel(usingFormatter: formatter)
        cell.reloadCell(with: viewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = subjectCurrentState.value.values[indexPath.row]
        switch viewModel {
        case .story(let story):
            coordinator?.showArticleView(with: story)
        case .video(let video):
            coordinator?.showVideo(with: video.url)
        }
    }
}
