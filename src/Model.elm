module Model exposing (..)

type alias Model =
    { paused : Bool
    , livingCells : List (Int, Int)
    , cameraCenter : (Int, Int)
    , width : Int
    , height : Int
    , cellSize : Int
    }

initModel : Model
initModel =
    { paused = True
    , livingCells = [(0,0), (1,-1), (2,-1), (2,0), (2,1)]
    , cameraCenter = (0, 0)
    , width = 900
    , height = 500
    , cellSize = 10
    }
