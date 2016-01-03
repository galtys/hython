module Hython.Primitive (callPrimitive)
where

import Control.Monad.IO.Class (liftIO)
import qualified Data.Text as T

import Hython.BuiltinTypes.Dict
import Hython.BuiltinTypes.List
import Hython.Types

callPrimitive :: MonadInterpreter m => String -> [Object] -> m Object
callPrimitive prim args = case (prim, args) of
    ("dict-clear", [Dict ref])          -> dictClear ref
    ("dict-contains", [Dict ref, obj])  -> dictContains ref obj
    ("dict-del", [Dict ref, obj])       -> dictDel ref obj
    ("dict-get", [Dict ref, obj])       -> dictGet ref obj
    ("dict-items", [Dict ref])          -> dictItems ref
    ("dict-length", [Dict ref])         -> dictLength ref
    ("dict-new", [])                    -> dictNew
    ("dict-set", [Dict ref, key, obj])  -> dictSet ref key obj
    ("list-append", [List ref, obj])    -> listAppend ref obj
    ("list-clear", [List ref])          -> listClear ref
    ("list-concat", [List l, List r])   -> listConcat l r
    ("list-get", [List l, obj])         -> listGet l obj
    ("list-length", [List l])           -> listLength l
    ("list-new", [])                    -> listNew
    ("print", _)                        -> do
        strs <- mapM toStr args
        liftIO . putStrLn . unwords $ strs
        return None

    ("str", [obj])                      -> do
        s <- toStr obj
        newString $ T.pack s
    _ -> do
        raise "SystemError" ("invalid primitive: " ++ prim)
        return None

