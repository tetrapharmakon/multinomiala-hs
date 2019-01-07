module Multinomiala.Tests where

import           Test.Hspec
import           Multinomiala
import           Test.QuickCheck

z = (0,[('x',1)])
z1 = (0, [('y',1)])
z2 = (0, [('y',4)])
z3 = (1, [('x',0)])
z4 = (1, [('y',0)])
a = monoInit 3 "x" [0] -- 3
a' = monoInit 3 "y" [0] -- 3
b = monoInit 1 "x" [1] -- x
c = monoInit 1 "y" [1] -- y
d = monoInit 1 "x" [3] -- x^3
e = monoInit 1 "y" [4] -- y^4
f = monoInit 2 "x" [1] -- 2x
g = monoInit 3 "xy" [2,1] --- 3x^2y
n = monoInit 3 "y" [-2] -- 3y^{-2}
m = monoInit (-3) "xz" [1,-3] -- -3xz^{-3}

u = monoInit 3 "xy" [2,3] -- 3x^2y^3
v = monoInit 6 "xz" [3,3] -- 6x^3z^3

main :: IO ()
main = hspec $ 
  describe "Multinomiala" $ do
  -- monoReduce
  it "3x^0 = 3" $ do
    monoReduce a `shouldBe` (3, [])
  it "x^0 = y^0" $ do
    monoReduce z3 == monoReduce z4 `shouldBe` True
  it "0x = 0y" $ do
    monoReduce z == monoReduce z1 `shouldBe` True
  it "init a negative coefficient" $ do
    m `shouldBe` (-3, [('x',1),('z',-3)])
  it "x^1x^1x^1 = x^3" $ do
    monoReduce (1, [('x', 1),('x', 1),('x', 1)]) `shouldBe` (1, [('x',3)])
  it "x  *y = xy" $ do
  -- monoMultiply
    monoMultiply b c `shouldBe` (1, [('x', 1), ('y', 1)])
  it "3 * x = 3x" $ do
    monoMultiply a b `shouldBe` (3, [('x', 1)])
  it "-3xz^{-3} * 3y^{-2}=-9xy^{-2}z^{-3}" $ do
    monoMultiply m n `shouldBe` (-9, [('x', 1), ('y', -2), ('z', -3)])
  -- monomial powers
  it "(x)^3 = x^3" $ do
    monoRaise b 3 `shouldBe` (1, [('x',3)])
  it "(x)^1 = x" $ do
    monoRaise b 1 `shouldBe` b
  it "(2x)^3 = 8x^3" $ do
    monoRaise f 3 `shouldBe` (8,[('x',3)])
  -- isMultiple
  it "x and 2x are multiples" $ do
    isMultiple b f `shouldBe` True
  it "y and 3y^{-1} are not multiples" $ do
    isMultiple c n `shouldBe` False  -- isLike
  -- monoExtractVar and
  -- monoExtractExps work fine
  it "monoInit (fst m) (var m) (exps m) == m" $ do
    monoInit (fst m) (monoExtractVar m) (monoExtractExps m) == m `shouldBe` True
  it "monoInit (fst a) (var a) (exps a) == a" $ do
    monoInit (fst a) (monoExtractVar a) (monoExtractExps a) == a `shouldBe` True
  it "monoInit (fst b) (var b) (exps b) == b" $ do
    monoInit (fst b) (monoExtractVar b) (monoExtractExps b) == b `shouldBe` True
  it "monoInit (fst c) (var c) (exps c) == c" $ do
    monoInit (fst c) (monoExtractVar c) (monoExtractExps c) == c `shouldBe` True
  it "monoInit (fst d) (var d) (exps d) == d" $ do
    monoInit (fst d) (monoExtractVar d) (monoExtractExps d) == d `shouldBe` True
  it "monoInit (fst e) (var e) (exps e) == e" $ do
    monoInit (fst e) (monoExtractVar e) (monoExtractExps e) == e `shouldBe` True
  it "monoInit (fst u) (var u) (exps u) == u" $ do
    monoInit (fst u) (monoExtractVar u) (monoExtractExps u) == u `shouldBe` True
  it "monoInit (fst v) (var v) (exps v) == v" $ do
    monoInit (fst v) (monoExtractVar v) (monoExtractExps v) == v `shouldBe` True
  -- monoInit
  it "init zero" $ do
    monoInit 0 "xy" [1,1] `shouldBe` (0, [])
  it "init a constant, 1" $ do
    monoInit 3 "" [0] `shouldBe` (3, [])
  it "init a constant, 2" $ do
    monoInit 2 "" [0] `shouldBe` (2, [])
  it "init u is correctly initialized" $ do
    u `shouldBe` monoInit 3 "xxyyy" [1,1,1,1,1]
  -- monoJoin
  -- monoShow
  -- monoRaise
  -- monoSum'
  -- monoSum
  -- polyReduce
  -- polySum'
  -- polySum
  -- polyShow