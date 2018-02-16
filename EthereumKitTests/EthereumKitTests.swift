//
//  EthereumKitTests.swift
//  EthereumKitTests
//
//  Created by yuzushioh on 2018/01/01.
//  Copyright © 2018 yuzushioh.
//

import XCTest
@testable import EthereumKit

class EthereumKitTests: XCTestCase {
    func testMenmonic() {
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        XCTAssertEqual(
            mnemonic,
            "abandon amount liar amount expire adjust cage candy arch gather drum buyer"
        )
        
        let entropy2 = Data(hex: "a26a4821e36c7f7dccaa5484c080cefa")
        let mnemonic2 = Mnemonic.create(entropy: entropy2)
        XCTAssertEqual(
            mnemonic2,
            "pen false anchor short side same crawl enhance luggage advice crisp village"
        )
    }
    
    func testSeedGeneration() {
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        XCTAssertEqual(
            seed.hex,
            "3779b041fab425e9c0fd55846b2a03e9a388fb12784067bd8ebdb464c2574a05bcc7a8eb54d7b2a2c8420ff60f630722ea5132d28605dbc996c8ca7d7a8311c0"
        )
        
        let entropy2 = Data(hex: "a26a4821e36c7f7dccaa5484c080cefa")
        let mnemonic2 = Mnemonic.create(entropy: entropy2)
        let seed2 = Mnemonic.createSeed(mnemonic: mnemonic2)
        XCTAssertEqual(
            seed2.hex,
            "2bb2ea75d2891584559506b2429426722bfa81958c824affb84b37def230fe94a7da1701d550fef6a216176de786150d0a4f2b7b3770139582c1c01a6958d91a"
        )
    }
    
    func testChildKeyDerivation() {
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let privateKey = PrivateKey(seed: seed, network: .main)
        
        // BIP44 key derivation
        // m/44'
        let purpose = privateKey.derived(at: 44, hardens: true)
        
        // m/44'/60'
        let coinType = purpose.derived(at: 60, hardens: true)
        
        // m/44'/60'/0'
        let account = coinType.derived(at: 0, hardens: true)
        
        // m/44'/60'/0'/0
        let change = account.derived(at: 0)
        
        // m/44'/60'/0'/0
        let firstPrivateKey = change.derived(at: 0)
        XCTAssertEqual(
            firstPrivateKey.publicKey.address,
            "0x83f1caAdaBeEC2945b73087F803d404F054Cc2B7"
        )
        
        XCTAssertEqual(
            firstPrivateKey.raw.hex,
            "df02cbea58239744a8a6ba328056309ae43f86fec6db45e5f782adcf38aacadf"
        )
    }
    
    func testAddressGeneration() {
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = Wallet(seed: seed, network: .main)
        
        let firstAddress = wallet.receiveAddress(at: 0)
        XCTAssertEqual(firstAddress, "0x83f1caAdaBeEC2945b73087F803d404F054Cc2B7")
        
        let secondAddress = wallet.receiveAddress(at: 1)
        XCTAssertEqual(secondAddress, "0xb3c3D923CFc4d551b38Db8A86BbA42B623D063cE")
        
        let thirdAddress = wallet.receiveAddress(at: 2)
        XCTAssertEqual(thirdAddress, "0x82e35B34CfBEB9704E51Eb17f8263d919786E66a")
        
        let forthAddress = wallet.receiveAddress(at: 3)
        XCTAssertEqual(forthAddress, "0xCF1D652DAb65ea4f10990FD2D2E59Cd7cbEb315a")
        
    }
}
