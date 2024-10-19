//
//  eCommerceAppTests.swift
//  eCommerceAppTests
//
//  Created by chvck on 12.10.2024.
//

import XCTest
import RxSwift
@testable import eCommerceApp

final class eCommerceAppTests: XCTestCase {

    var repository: Repository!
    var disposeBag: DisposeBag!
    
    
    override func setUpWithError() throws {
        repository = Repository()
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        repository = nil
        disposeBag = nil
    }

    func testExample() throws {
     
        func testFetchProducts() throws {
              let expectation = self.expectation(description: "Products fetched")
              
              repository.fetchProducts()
              
              repository.products
                  .subscribe(onNext: { products in
                      XCTAssertFalse(products.isEmpty, "Product list should not be empty")
                      expectation.fulfill()
                  })
                  .disposed(by: disposeBag)
              
              waitForExpectations(timeout: 5.0, handler: nil)
          }
        func testAddToCart() throws {
               let expectation = self.expectation(description: "Product added to cart")
               
               repository.addToCart(ad: "Sample Product", resim: "sample_image.png", kategori: "Teknoloji", fiyat: 100, marka: "BrandX", siparisAdeti: 1, kullaniciAdi: "testUser")
               
               repository.cartProducts
                   .subscribe(onNext: { cartProducts in
                       let cartProduct = cartProducts.first { $0.ad == "Sample Product" }
                       XCTAssertNotNil(cartProduct, "Product should be in cart")
                       expectation.fulfill()
                   })
                   .disposed(by: disposeBag)
               
               waitForExpectations(timeout: 5.0, handler: nil)
           }
        func testDeleteFromCart() throws {
             let expectation = self.expectation(description: "Product removed from cart")
             
             repository.addToCart(ad: "Sample Product", resim: "sample_image.png", kategori: "Teknoloji", fiyat: 100, marka: "BrandX", siparisAdeti: 1, kullaniciAdi: "testUser")
             
             repository.cartProducts
                 .take(1)
                 .subscribe(onNext: { cartProducts in
                     guard let cartProduct = cartProducts.first(where: { $0.ad == "Sample Product" }) else {
                         XCTFail("Product not found in cart")
                         return
                     }

                     self.repository.deleteFromCart(ad: cartProduct.ad!, resim: cartProduct.resim!, kategori: cartProduct.kategori!, fiyat: cartProduct.fiyat!, marka: cartProduct.marka!, siparisAdeti: 1, kullaniciAdi: "testUser")
                 })
                 .disposed(by: disposeBag)
             
             repository.cartProducts
                 .subscribe(onNext: { cartProducts in
                     XCTAssertFalse(cartProducts.contains(where: { $0.ad == "Sample Product" }), "Product should be removed from cart")
                     expectation.fulfill()
                 })
                 .disposed(by: disposeBag)

             waitForExpectations(timeout: 5.0, handler: nil)
         }
        
        func testCalculateTotalPrice() throws {
            let expectation = self.expectation(description: "Total price calculated")
            
            repository.addToCart(ad: "Sample Product 1", resim: "sample_image_1.png", kategori: "Teknoloji", fiyat: 100, marka: "BrandX", siparisAdeti: 2, kullaniciAdi: "testUser")
            repository.addToCart(ad: "Sample Product 2", resim: "sample_image_2.png", kategori: "Kozmetik", fiyat: 50, marka: "BrandY", siparisAdeti: 3, kullaniciAdi: "testUser")
            
            repository.totalPrice
                .subscribe(onNext: { total in
                    XCTAssertEqual(total, 350, "Total price should be 350")
                    expectation.fulfill()
                })
                .disposed(by: disposeBag)
            
            waitForExpectations(timeout: 5.0, handler: nil)
        }
        
        func testFetchCurrentUserData() throws {
            let expectation = self.expectation(description: "User data fetched")
            
            repository.fetchCurrentUserData()
            
            repository.currentUser
                .subscribe(onNext: { user in
                    XCTAssertNotNil(user, "User data should not be nil")
                    XCTAssertEqual(user?.username, "testUser", "User username should match")
                    expectation.fulfill()
                })
                .disposed(by: disposeBag)

            waitForExpectations(timeout: 5.0, handler: nil)
        }
        
        
    }

    func testPerformanceExample() throws {
         self.measure {
             let expectation = self.expectation(description: "Products fetched")
             repository.fetchProducts()
             repository.products
                 .subscribe(onNext: { products in
                     XCTAssertFalse(products.isEmpty, "Product list should not be empty")
                     expectation.fulfill()
                 })
                 .disposed(by: disposeBag)
             waitForExpectations(timeout: 5.0, handler: nil)
         }
     }
    
    

}
