//
//  AppDelegate.swift
//  Nearby
//
//  Created by soomin on 7/1/26.
//

import UIKit

import GoogleMaps
import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        do {
            let googleMapAPIKey = try AppConfig.googleMapsAPIKey()
            GMSServices.provideAPIKey(googleMapAPIKey)
        } catch {
            AppLogger.error(error)
            fatalError("Google Maps API key is missing. Set GOOGLE_MAPS_API_KEY before creating GMSMapView.")
        }
        
        do {
            let kakaoAPIKey = try AppConfig.kakaoAPIKey()
            KakaoSDK.initSDK(appKey: kakaoAPIKey)
        } catch {
            AppLogger.error(error)
            fatalError("Kakao App key is missing. Set KAKAO_APP_KEY before initializing KakaoSDK.")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
