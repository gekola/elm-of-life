module Update exposing (..)

import Keyboard exposing (..)
import Time exposing (..)

import Model exposing (Model, initModel)
import NextStep exposing (nextStep)

type Msg
    = Start
    | Pause
    | Tick Bool Time
    | Flip (Int, Int)
    | MoveCamera (Int, Int)
    | ResetCamera
    | ChangeCellSize Int
    | ResetCellSize
    | None

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Start ->
            ({ model | paused = False }, Cmd.none)
        Pause ->
            ({ model | paused = True }, Cmd.none)
        Tick force newtime ->
            if force || not model.paused
            then ({ model | livingCells = nextStep model.livingCells }, Cmd.none)
            else (model, Cmd.none)
        Flip point ->
            let livingCells = if List.member point model.livingCells
                              then List.filter ((/=) point) model.livingCells
                              else point :: model.livingCells
            in ({ model | livingCells = livingCells }, Cmd.none)
        MoveCamera (dx, dy) ->
            let (x, y)       = model.cameraCenter
                cameraCenter = (x + dx, y + dy)
            in ({ model | cameraCenter = cameraCenter }, Cmd.none)
        ResetCamera ->
            ({ model | cameraCenter = (0, 0) }, Cmd.none)
        ChangeCellSize d ->
            let oldCellSize = model.cellSize
                cellSize    = max 6 <| oldCellSize + d
            in ({ model | cellSize = cellSize }, Cmd.none)
        ResetCellSize ->
            ({ model | cellSize = initModel.cellSize }, Cmd.none)
        None ->
            (model, Cmd.none)

keyMsg : Model -> Keyboard.KeyCode -> Msg
keyMsg { paused, cameraCenter } code =
    case code of
        37 -> MoveCamera (-1,  0) -- left arrow
        65 -> MoveCamera (-1,  0) -- 'a'
        38 -> MoveCamera ( 0,  1) -- up arrow
        87 -> MoveCamera ( 0,  1) -- 'w'
        39 -> MoveCamera ( 1,  0) -- right arrow
        68 -> MoveCamera ( 1,  0) -- 'd'
        40 -> MoveCamera ( 0, -1) -- down arrow
        83 -> MoveCamera ( 0, -1) -- 's'
        88 -> ResetCamera         -- 'x'
        32 -> Tick True 0
        80 -> if paused then Start else Pause
        48 -> ResetCellSize       -- '0'
        187 -> ChangeCellSize  1  -- '='
        189 -> ChangeCellSize -1  -- '-'
        _   -> None

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every second <| Tick False
        , Keyboard.ups <| keyMsg model
        ]
