//
//  LocationManager.swift
//  you
//
//  Created by 翁益亨 on 2024/6/25.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {

  // 记录位置信息
  @Published var currentLocation: CLLocationCoordinate2D?

  // 初始化CLLocationManager实例
  private var locManager = CLLocationManager()
    
  //位置变更时需要回调Wifi连接信息
  var didResultCallback: ((Bool) -> Void)?

  // 传递失败、成功回调函数
  func checkLocationAuthorization(resultCallBack: @escaping (Bool) -> Void) {
    // 设置代理
    locManager.delegate = self
      
    didResultCallback = resultCallBack

    // 获取用户授权状态
    let authorizationStatus = locManager.authorizationStatus


    DispatchQueue.global().async { [weak self] in
      // 判断用户设备的系统位置权限是否开启，而非App的。该判断需要异步进行，否则会卡主线程。
      if CLLocationManager.locationServicesEnabled() {
        // 如果设备系统位置权限开启了，回主线程继续操作
        DispatchQueue.main.async {
          if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            // 如果用户授权了，开启位置更新。
            self?.locManager.startUpdatingLocation()
          } else if authorizationStatus == .notDetermined {
            // 如果用户未曾选择过，那么弹出授权框。
            self?.locManager.requestWhenInUseAuthorization()
          } else {
            // 用户拒绝了，停止位置更新。
            self?.locManager.stopUpdatingLocation()
          }
        }
      } else {
        // 如果设备系统位置权限未开启，回主线程继续操作
        DispatchQueue.main.async {
          if authorizationStatus == .notDetermined {
            // 如果用户未曾选择过，那么弹出授权框。
            self?.locManager.requestWhenInUseAuthorization()
          } else {
            // 因系统位置权限未开启，停止位置更新。
            self?.locManager.stopUpdatingLocation()
          }
        }
      }
    }

  }
    
  // MARK: - 暂停地区更新，默认情况下开启定位后在使用期间定时刷新地域信息，也就是说一直更新当前连接的Wifi信息
    func stopUpdateLocation(){
        DispatchQueue.global().async { [weak self] in
            DispatchQueue.main.async {
                self?.locManager.stopUpdatingLocation()
            }
        }
    }

  // MARK: - CLLocationManagerDelegate

  // 每当位置更新时都会被调用，这里更新currentLocation变量。
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let newLocation = manager.location, !(newLocation.coordinate.longitude == 0.0 && newLocation.coordinate.latitude == 0.0) {
      currentLocation = newLocation.coordinate
      didResultCallback!(true)
    }
  }

  // 当位置管理器无法获取位置或发生错误时调用。
  func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
    currentLocation = nil
    locManager.delegate = nil
    locManager.stopUpdatingLocation()
    didResultCallback!(false)
  }

  // 当用户的位置权限状态发生变化时调用，例如用户从拒绝状态改为允许状态。用于根据当前的授权状态调整应用的行为，如在用户授权后开始位置更新。
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    if manager.authorizationStatus == .denied {
      locManager.stopUpdatingLocation()
      //提示弹窗显示选择不允许时的回调
      didResultCallback!(false)
    } else if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
      locManager.startUpdatingLocation()
    }
  }
}
