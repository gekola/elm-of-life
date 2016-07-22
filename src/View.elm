module View exposing (view)

import Css exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List exposing (map, member)

import Model exposing (Model)
import Update exposing (..)

cellView : Model -> Int -> Int -> Html Msg
cellView model y x =
    let alive = (x, y) `member` model.livingCells
        cellClass = if alive then "cell-alive" else "cell-dead"
    in
        div [ class <| "cell " ++ cellClass
            , onClick <| Flip (x, y) ] []

cellsRowView : Model -> Int -> Html Msg
cellsRowView model y =
    let hwidth  = model.width // ((model.cellSize + 2) * 2)
        (cx, _) = model.cameraCenter
        cellXs  = [cx-hwidth .. cx+hwidth]
    in
        div [ class "cells-row" ]
            <| map (cellView model y) cellXs

view : Model -> Html Msg
view model =
    div []
        [ stylesheet [ ".cells-field" => [ "display"        :- "flex"
                                         , "flex-direction" :- "column"
                                         , "margin"         :- "10px"
                                         ]
                     , ".cells-row"   => [ "display"        :- "flex"
                                         , "flex-direction" :- "row"
                                         ]
                     , ".cell" =>
                         let dimention = toString model.cellSize ++ "px"
                         in [ "width"  :- dimention
                            , "height" :- dimention
                            , "border" :- "solid 1px grey"
                            ]
                     , ".cell-alive" => [ "background-color" :- "black" ]
                     , ".cell-dead"  => [ "background-color" :- "white" ]
                     ]
        , nav []
              [ button [ onClick <| Tick True 0 ] [ text "Step" ]
              , if model.paused
                then
                    button [ onClick Start ] [ text "Start" ]
                else
                    button [ onClick Pause ] [ text "Pause" ]
              ]
        , let hheight = model.height // ((model.cellSize + 2) * 2)
              (_, cy) = model.cameraCenter
              cellYs  = List.reverse [cy-hheight .. cy+hheight]
          in
              div [ class "cells-field" ]
                  <| map (cellsRowView model) cellYs
        ]
