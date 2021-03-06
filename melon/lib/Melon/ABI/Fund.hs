{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Melon.ABI.Fund where

import Data.Semigroup ((<>))
import qualified Generics.SOP.Universe
import GHC.Generics (Generic)
import Network.Ethereum.ABI.Class (ABIGet, ABIPut, ABIType (isDynamic))
import Network.Ethereum.ABI.Codec (encode)
import Network.Ethereum.ABI.Prim.Address (Address)
import Network.Ethereum.ABI.Prim.Bytes (BytesN)
import Network.Ethereum.ABI.Prim.Int (UIntN)
import Network.Ethereum.Contract.Method (Method (selector))
import Network.Ethereum.Web3.Eth (sendTransaction)
import Network.Ethereum.Web3.Provider (Web3)
import Network.Ethereum.Web3.Types (Call (..), Hash)

import Melon.TH


[melonAbiFrom|Fund|]

data Constructor
  = Constructor
      Address
      (BytesN 32)
      Address
      (UIntN 256)
      (UIntN 256)
      Address
      Address
      Address
      [Address]
  deriving Generic
instance Generics.SOP.Universe.Generic Constructor
instance ABIGet Constructor
instance ABIPut Constructor
instance ABIType Constructor where
  isDynamic = const False
instance Method Constructor where
  selector = mempty

constructor
  :: Call
  -> Address
  -> BytesN 32
  -> Address
  -> UIntN 256
  -> UIntN 256
  -> Address
  -> Address
  -> Address
  -> [Address]
  -> Web3 Hash
constructor
  call'
  ofManager'
  withName'
  ofQuoteAsset'
  ofManagementFee'
  ofPerformanceFee'
  ofCompliance'
  ofRiskMgmt'
  ofPriceFeed'
  ofExchanges'
  =
  sendTransaction call'
    { callData = Just $ contractBin <> encode (Constructor
        ofManager'
        withName'
        ofQuoteAsset'
        ofManagementFee'
        ofPerformanceFee'
        ofCompliance'
        ofRiskMgmt'
        ofPriceFeed'
        ofExchanges')
    , callValue = Nothing
    }
