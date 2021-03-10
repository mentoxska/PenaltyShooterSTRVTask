//
//  ViewController.swift
//  PenaltyShooter
//
//  Created by Branislav on 17/02/2021.
//

import UIKit
import SnapKit
import RxSwift
import PKHUD

class MainViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private let backgroundView = UIImageView()
    private let shootButton = UIButton()
    private let goalLabel = UILabel()
    private var pulse: PulsingLayer?
    private let viewModel: ShootViewModelProtocol = ShootViewModel()
    private var shootDetails: ShootDetails?
    private let disposeBag = DisposeBag()
    private var touchPoint: CGPoint?
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackground()
        setUpShootButton()
        setUpGoalLabel()
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchCallback(sender:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        setupViewModel()
    }
    // Checking if touch occurs inside of net/goal
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        let deviceHeight = UIScreen.main.bounds.size.height
        let deviceWidth = UIScreen.main.bounds.size.width
        let topLeftBound = 140 / 414 * deviceHeight
        let bottomLeftBound = 280 / 414 * deviceHeight
        let topRightBound = 140 / 736 * deviceWidth
        let bottomRightBound = 600 / 736 * deviceWidth
        
        let point = touch.location(in: backgroundView)
        
        if point.y >= topLeftBound && point.y <= bottomLeftBound && point.x >= topRightBound && point.x <= bottomRightBound {
            return true
        }
        return false
    }
    
    // callback after touch occurs, we filter if it happens in selected area (goal)
    @objc private func touchCallback(sender: UITapGestureRecognizer) {
        touchPoint = sender.location(in: view)
        let circleRadius = 30
        let xPos = Int(touchPoint?.x ?? 0) - circleRadius / 2
        let yPos = Int(touchPoint?.y ?? 0) - circleRadius / 2
        let dynamicView = UIView(frame: CGRect(x: xPos, y: yPos, width: circleRadius, height: circleRadius))
        dynamicView.tag = 1
        dynamicView.backgroundColor = UIColor.penaltyBlue.withAlphaComponent(0.5)
        dynamicView.layer.cornerRadius = dynamicView.frame.size.width / 2
        dynamicView.layer.borderWidth = 2
        dynamicView.layer.borderColor = UIColor.penaltyBlue.cgColor
        
        for view in view.subviews where view.tag == 1 {
            view.removeFromSuperview()
        }
        if let sublayers = view.layer.sublayers {
            for layer in sublayers where layer is PulsingLayer {
                layer.removeFromSuperlayer()
            }
        }
        
        view.addSubview(dynamicView)
        pulse = PulsingLayer(radius: 40, position: dynamicView.center, endPulseRadius: CGFloat(circleRadius))
        if let pulse = pulse {
            view.layer.insertSublayer(pulse, below: dynamicView.layer)
        }
    }

    @objc private func shootDidPress() {
        
        guard Reachability.isConnectedToNetwork() else {
            let hud = PKHUDErrorView(title: Strings.error, subtitle: Strings.reachabilityErrorSubtitle)
            hud.subtitleLabel.textAlignment = .center
            PKHUD.sharedHUD.contentView = hud
            PKHUD.sharedHUD.show()
            PKHUD.sharedHUD.hide(afterDelay: 2.5)
            return
        }
        pulse?.pauseAnimation()
        let radius = Float(pulse?.presentation()?.frame.width ?? 0)
        let yPos = Float(touchPoint?.y ?? 0)
        let xPos = Float(touchPoint?.x ?? 0)
        shootDetails = ShootDetails(xPos: xPos, yPos: yPos, radius: radius)
        shootButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 0.3, delay: 0, options: [.repeat, .autoreverse], animations: { () -> Void in
            self.shootButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    private func setupViewModel() {
       viewModel.shootResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] shoot in
                self?.displayShootResult( shoot)
                self?.shootButton.layer.removeAllAnimations()
            }, onError: { _ in
                let hud = PKHUDErrorView(title: Strings.error, subtitle: Strings.serversErrorSubtitle)
                hud.subtitleLabel.textAlignment = .center
                PKHUD.sharedHUD.contentView = hud
                PKHUD.sharedHUD.show()
                PKHUD.sharedHUD.hide(afterDelay: 5)
            })
            .disposed(by: disposeBag)
        
        shootButton.rx.tap.asObservable()
            
            .subscribe(onNext: { [weak self] _ in
                if let shootDetailsModel = self?.shootDetails {
                    self?.viewModel.getShootInfo(by: shootDetailsModel)
                }
            }).disposed(by: disposeBag)
    }
    
   private func displayShootResult(_ shootResult: ShootResult?) {
        if let scored = shootResult?.scored {
            if scored {
                goalLabel.text = Strings.goal
            } else {
                goalLabel.text = Strings.miss
            }
            goalLabel.isHidden = false
            goalLabel.alpha = 1
            UIView.animate(withDuration: 2, delay: 1, options: UIView.AnimationOptions.transitionFlipFromTop, animations: {
                self.goalLabel.alpha = 0
            }, completion: { _ in
                self.goalLabel.isHidden = true
                self.pulse?.resumeAnimation()
            })
        }
    }
    
    // MARK: Setup UI

    private func setUpBackground() {
        self.view.backgroundColor = UIColor.black
        self.view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        let bgImage = UIImage.backgroundImage
        backgroundView.image = bgImage
    }
    
    private func setUpShootButton() {
        view.addSubview(shootButton)
        shootButton.snp.makeConstraints { (make) in
            make.height.equalTo(70)
            make.width.equalTo(70)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-15)
        }
        let bgImage = UIImage.shootButtonImage
        shootButton.setImage(bgImage, for: .normal)
        shootButton.addTarget(self, action: #selector(shootDidPress), for: .touchUpInside)
    }
    
    private func setUpGoalLabel() {
        view.addSubview(goalLabel)
        goalLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(view)
            make.centerX.equalTo(view)
        }
        goalLabel.font = UIFont.generalFont
        goalLabel.textColor = .white
        goalLabel.layer.zPosition = 1
    }
}
