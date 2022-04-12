//
//  OnboardingViewController.swift
//  emcesatu
//
//  Created by Marshall Kurniawan on 07/04/22.
//

import UIKit

class OnboardingViewController: UIViewController {
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides: [OnboardingSlide] = []
    var currentPage = 0 {
        didSet{
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextButton.isHidden = false
                skipButton.isHidden = true
            } else {
                nextButton.isHidden = true
                skipButton.isHidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isHidden = true
        slides = [
            OnboardingSlide(title: "Welcome", desc: "<App Name> is an app designed for programmers to stay productive.", image: #imageLiteral(resourceName: "onboarding-1")),
            OnboardingSlide(title: "Task List", desc: "You can write as many tasks as you want and provide its details like difficulty and deadlines.", image: #imageLiteral(resourceName: "onboarding-2")),
            OnboardingSlide(title: "1-3-5 Rule", desc: "We recommend for you to complete 1 hard task, 3 medium task, and 5 easy tasks per day to stay productive without feeling burned out.", image: #imageLiteral(resourceName: "onboarding-3")),
            OnboardingSlide(title: "Timer", desc: "Use the timer feature to set your work time frame and we will remind you to take a break every few minutes.", image: #imageLiteral(resourceName: "onboarding-4")),
            OnboardingSlide(title: "Ready?", desc: "Okay! That's it for our intro, let's jump to the app right away!", image: #imageLiteral(resourceName: "onboarding-5"))
                ]
                collectionView.delegate = self
                collectionView.dataSource = self
    }
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        if currentPage == slides.count - 1 {
            let controller = storyboard?.instantiateViewController(withIdentifier: "HomeTBC") as! UITabBarController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .crossDissolve
            UserDefaults.standard.hasOnboarded = true
            UserDefaults.standard.set(date: Date(), forKey: "appDate")
            present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func skipButtonClicked(_ sender: UIButton) {
        currentPage = slides.count - 1
        let indexPath = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    @IBAction func pageControllerClicked(_ sender: UIPageControl) {
        currentPage = pageControl.currentPage
        let indexPath = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
}

extension OnboardingViewController:
    UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
    
}
