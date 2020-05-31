//
//  ImagePickerWrapper.swift
//  SafePath-Family-iOS
//
//  Created by Michael Wells on 5/28/20.
//  Copyright © 2020 Smith Micro Software, Inc. All rights reserved.
//

import UIKit

class CameraPresentationWrapper {
	
	static func createPresenterWith(viewController: UIViewController, completion: @escaping (UIImage)-> Void) {
		presenterBuilder(viewController: viewController, completion: completion)
	}
	
	private static func presenterBuilder(viewController: UIViewController, completion: @escaping (UIImage)-> Void) {
//		var initializedFlag = false
//		defer { initializedFlag.toggle() }
		
		var ptrPresenter: UnsafeMutablePointer<CameraPresenter>
		ptrPresenter = UnsafeMutablePointer<CameraPresenter>.allocate(capacity: 1)
		
		func finishedHandler() {
//			guard initializedFlag else { return }
			guard memoryChecker(UnsafeMutableRawPointer(ptrPresenter)) else { return }
			ptrPresenter.deinitialize(count: 1)
			ptrPresenter.deallocate()
		}
		
		finishedHandler()
		
		ptrPresenter.initialize(to: CameraPresenter(presentingViewController: viewController, finishedHandler: finishedHandler, completion: completion))
	}
	
	//MARK: - Wrapped Camera API Presenter
	
	final class CameraPresenter: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
		
		private let cameraAccessController = UIImagePickerController()
		private var presentingViewController: UIViewController
		private var imageCapturer: (UIImage)-> Void
		private var finishedHandler: (()-> Void)
		
		init(presentingViewController: UIViewController, finishedHandler: @escaping ()-> Void ,completion: @escaping (UIImage)-> Void) {
			self.presentingViewController = presentingViewController
			self.imageCapturer = completion
			self.finishedHandler = finishedHandler
			super.init()
			cameraAccessController.delegate = self
			accessDeviceCamera()
		}
		
		deinit {
			print("Deallocated Successfully")
		}
		
		private func accessDeviceCamera() {
			guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
			cameraAccessController.sourceType = .camera
			cameraAccessController.cameraCaptureMode = .photo
			cameraAccessController.showsCameraControls = true
			cameraAccessController.allowsEditing = true
			
			presentingViewController.present(cameraAccessController, animated: true)
		}
		
		func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
			guard let capturedImage = info[.editedImage] as? UIImage else {
				return
			}
			imageCapturer(capturedImage)
			finishTrigger()
		}
		
		func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
			finishTrigger()
		}
		
		private func finishTrigger() {
			cameraAccessController.dismiss(animated: true)
			finishedHandler()
		}
	}
}