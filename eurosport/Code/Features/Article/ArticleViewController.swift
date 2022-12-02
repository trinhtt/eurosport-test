//
//  ArticleViewController.swift
//  eurosport
//
//  Created by Thanh on 02/12/2022.
//

import UIKit
import Kingfisher

final class ArticleViewController: ViewController {
    
    private var story: Story
    
    private lazy var scrollView: UIScrollView = createScrollView()
    private lazy var scrollableContentView = UIView()
    private lazy var thumbnailImageView: UIImageView = createThumbnailImageView()
    private lazy var categoryContainerView: UIView = createCategoryLabelContainerView()
    private lazy var categoryLabel: UILabel = createCategoryLabel()
    private lazy var titleLabel: UILabel = createTitleLabel()
    private lazy var authorLabel: UILabel = createAuthorLabel()
    private lazy var articleLabel: UILabel = createArticleLabel()
    
    // MARK: - Init
    @available(*, unavailable)
    init() {
        fatalError()
    }
    
    @available(*, unavailable)
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    required init(story: Story) {
        self.story = story
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViewHierarchy()
        setConstraints()
        loadArticle()
    }
    
    private func buildViewHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollableContentView)
        scrollableContentView.addSubview(thumbnailImageView)
        scrollableContentView.addSubview(categoryContainerView)
        categoryContainerView.addSubview(categoryLabel)
        scrollableContentView.addSubview(titleLabel)
        scrollableContentView.addSubview(authorLabel)
        scrollableContentView.addSubview(articleLabel)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Asset.Images.share.image, style: .done, target: self, action: #selector(shareArticle))
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate(scrollView.constraintsForAnchoringTo(boundsOf: view))
        
        NSLayoutConstraint.activate([
            scrollableContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollableContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollableContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollableContentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollableContentView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: scrollableContentView.topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: scrollableContentView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: scrollableContentView.trailingAnchor),
            thumbnailImageView.centerXAnchor.constraint(equalTo: scrollableContentView.centerXAnchor),
            thumbnailImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            thumbnailImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9/16)
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
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(greaterThanOrEqualTo: authorLabel.topAnchor, constant: -6)
        ])

        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        ])

        NSLayoutConstraint.activate([
            articleLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 20),
            articleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            articleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        ])
    }
    
    private func loadArticle() {
        categoryLabel.text = story.sport.name
        titleLabel.text = story.title
        authorLabel.text = story.author
        articleLabel.text = story.teaser
        if let url = URL(string: story.image) {
            thumbnailImageView.kf.setImage(with: url)
        }
    }
    
    @objc
    private func shareArticle() {
        let textToShare = """
        \(story.title)
        \(story.teaser)
        """
        let shareActivityController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        present(shareActivityController, animated: true)
    }
}

extension ArticleViewController {
    private func createScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.clipsToBounds = false
        return scrollView
    }
    
    private func createThumbnailImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
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
    
    private func createAuthorLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12, weight: .light)
        
        return label
    }
    
    private func createArticleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        
        return label
    }
}
