{-# LANGUAGE BangPatterns #-}

module Hash.Zobrist (
    ZKey,
    zobMove,
    zobPiece,
    zobCastKw, zobCastQw, zobCastKb, zobCastQb,
    zobEP
) where

import Data.Array.Base
import Data.Ix
import GHC.Arr (unsafeIndex)
import System.Random
-- import Control.Exception (assert)

import Struct.Struct

genInit, zLen :: Int
genInit = 118863
zLen = 781

zobrist :: UArray Int ZKey
zobrist = listArray (0, zLen-1) $ take zLen $ randoms (mkStdGen genInit)

-- When black is moving: xor with that number
zobMove :: ZKey
zobMove = fromIntegral $ zobrist `unsafeAt` (12*64)

-- For every pice type of every color on every valid
-- field: one index in zobrist (0 to 12*64-1)
{-# INLINE zobPiece #-}
zobPiece :: Color -> Piece -> Square -> ZKey
zobPiece c p sq =
  zobrist `unsafeAt` index ((White,Pawn,0),(Black,King,63)) (c, p, sq)

zobCastBegin :: Int
zobCastBegin = 12*64+1

zobCastKw, zobCastQw, zobCastKb, zobCastQb :: ZKey
zobCastKw = zobrist `unsafeAt` zobCastBegin
zobCastQw = zobrist `unsafeAt` (zobCastBegin + 1)
zobCastKb = zobrist `unsafeAt` (zobCastBegin + 2)
zobCastQb = zobrist `unsafeAt` (zobCastBegin + 3)

zobEP :: Int -> ZKey
{-# INLINE zobEP #-}
zobEP x = zobrist `unsafeAt` (zobCastBegin + 4 + x)
