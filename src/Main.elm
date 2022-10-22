port module Main exposing (..)

import Array
import Browser
import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (class, src)


port receiveRandom : (Int -> msg) -> Sub msg


port receiveCountDown : (String -> msg) -> Sub msg


port generateRandom : Int -> Cmd msg


port countdownTo : String -> Cmd msg



---- MODEL ----


type alias Model =
    { posterIndex : Int, countdown : String }


init : ( Model, Cmd Msg )
init =
    ( { posterIndex = 0, countdown = "" }, Cmd.batch [ generateRandom <| List.length posters, countdownTo "April 27, 2023" ] )



---- UPDATE ----


type Msg
    = GotRandom Int
    | GotCountDown String
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotCountDown countdown ->
            ( { model | countdown = countdown }, Cmd.none )

        GotRandom randomIndex ->
            ( { model | posterIndex = randomIndex }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


posters : List String
posters =
    [ "mario_movie1.jpeg"
    , "mario_movie1.png"
    , "mario_movie2.jpeg"
    , "mario_movie3.webp"
    ]


view : Model -> Html Msg
view model =
    let
        postersArray =
            Array.fromList posters

        poster =
            Array.get model.posterIndex postersArray |> Maybe.withDefault ""
    in
    div [ class "container mx-auto" ]
        [ img [ src poster ] []
        , h1 [] [ text model.countdown ]
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = \_ -> Sub.batch [ receiveRandom GotRandom, receiveCountDown GotCountDown ]
        }
