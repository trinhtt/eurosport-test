//
//  HomeTableViewCell.swift
//  eurosport
//
//  Created by Thanh on 02/12/2022.
//

import Kingfisher
import UIKit

struct HomeTableViewCellViewModel: Equatable {
    var title: String
    var subtitle: String
    var thumbnailURL: String
    var type: ArticleType
    var category: String
}

final class HomeTableViewCell: UITableViewCell {
    
    private lazy var containerView: UIView = createContainerView()
    private lazy var thumbnailImageView: UIImageView = createThumbnailImageView()
    private lazy var categoryContainerView: UIView = createCategoryLabelContainerView()
    private lazy var categoryLabel: UILabel = createCategoryLabel()
    private lazy var titleLabel: UILabel = createTitleLabel()
    private lazy var subtitleLabel: UILabel = createSubtitleLabel()
    private(set) lazy var playImageView: UIImageView = createPlayImageView()
    private lazy var highlightedView: UIView = createHighlightedView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        buildViewHierarchy()
        setConstraints()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        highlightedView.backgroundColor = highlighted ? .white.withAlphaComponent(0.5) : .clear
    }
    
    private func buildViewHierarchy() {
        contentView.addSubview(containerView)
        contentView.addSubview(highlightedView)
        containerView.addSubview(thumbnailImageView)
        containerView.addSubview(categoryContainerView)
        categoryContainerView.addSubview(categoryLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(playImageView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate(containerView.constraintsForAnchoringTo(boundsOf: contentView, withInsets: NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)))
        
        NSLayoutConstraint.activate(highlightedView.constraintsForAnchoringTo(boundsOf: contentView, withInsets: NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)))
        
        NSLayoutConstraint.activate([
            thumbnailImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            thumbnailImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor, multiplier: 9/16)
        ])
        
        NSLayoutConstraint.activate([
            categoryContainerView.centerYAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor),
            categoryContainerView.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: 12),
        ])
        
        NSLayoutConstraint.activate(
            categoryLabel.constraintsForAnchoringTo(boundsOf: categoryContainerView, withInsets: NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6))
        )
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: categoryContainerView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(greaterThanOrEqualTo: subtitleLabel.topAnchor, constant: -6)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            playImageView.centerXAnchor.constraint(equalTo: thumbnailImageView.centerXAnchor),
            playImageView.centerYAnchor.constraint(equalTo: thumbnailImageView.centerYAnchor)
        ])
    }
    
    func reloadCell(with viewModel: HomeTableViewCellViewModel) {
        categoryLabel.text = viewModel.category
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        playImageView.isHidden = viewModel.type == .story
        if let url = URL(string: viewModel.thumbnailURL) {
            thumbnailImageView.kf.setImage(with: url)
        }
    }
}

extension HomeTableViewCell {
    
    private func createContainerView() -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
        
        return containerView
    }
    
    private func createThumbnailImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
    
    private func createCategoryLabelContainerView() -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = Asset.Colors.main.color
        containerView.layer.cornerRadius = 6
        
        return containerView
    }
    
    private func createCategoryLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        
        return label
    }
    
    private func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 3
        
        return label
    }
    
    private func createSubtitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12, weight: .light)
        
        return label
    }
    
    private func createPlayImageView() -> UIImageView {
        let imageView = UIImageView(image: Asset.Images.play.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        return imageView
    }
    
    private func createHighlightedView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.backgroundColor = .clear
        return view
    }
}
