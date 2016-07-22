module NextStep exposing (nextStep)

import Dict exposing (Dict)
import List
import Maybe exposing (Maybe)

incPoint : Maybe Int -> Maybe Int
incPoint was =
    Just (1 + Maybe.withDefault 0 was)

markCells : (Int, Int) -> Dict (Int, Int) Int -> Dict (Int, Int) Int
markCells (x, y) dict =
    List.foldl (\ p -> Dict.update p incPoint) dict
        [ (x-1, y-1), (x, y-1), (x+1, y-1)
        , (x-1, y),             (x+1, y)
        , (x-1, y+1), (x, y+1), (x+1, y+1)
        ]

nextStep : List (Int, Int) -> List (Int, Int)
nextStep wereAlive =
    let cellScores = List.foldl markCells Dict.empty wereAlive
        isAlive point score =
            if score == 3
            then True
            else if score == 2
                 then List.member point wereAlive
                 else False
    in
        Dict.filter isAlive cellScores
        |> Dict.keys
