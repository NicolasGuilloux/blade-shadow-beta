module Template.Banner exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Libs.Tailwind exposing (..)


banner : List (Html msg) -> Html msg
banner subBanner =
    div []
        [ div [ pt8, pb16 ]
            [ div [ container, px3, mxAuto, flex, flexWrap, flexCol, justifyCenter, itemsCenter, mdFlexRow ]
                subBanner
            ]
        , bannerSeparation
        ]


bannerSeparation : Html msg
bannerSeparation =
    div [ relative, negMt12, lgNegMt24 ]
        [ object [ attribute "data" "images/banner_separation.svg" ] []
        ]
