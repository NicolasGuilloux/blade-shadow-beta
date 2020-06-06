module Base.Utils exposing (..)

import Html exposing (Attribute, Html, text)
import Html.Attributes exposing (class)


pipe : a -> (a -> b) -> b
pipe arg func =
    func arg


flip : (a -> b -> c) -> b -> a -> c
flip function arg1 arg2 =
    function arg2 arg1


htmlJust : Maybe a -> (a -> Html msg) -> Html msg
htmlJust mValue view =
    case mValue of
        Just value ->
            view value

        Nothing ->
            text ""


htmlJust_ : Maybe a -> Html msg -> Html msg
htmlJust_ mValue view =
    htmlJust mValue <| \_ -> view


htmlWhen : Bool -> Html msg -> Html msg
htmlWhen predicate view =
    if predicate then
        view

    else
        text ""


attributeWhen : Bool -> Attribute msg -> Attribute msg
attributeWhen predicate attribute =
    if predicate then
        attribute

    else
        class ""
