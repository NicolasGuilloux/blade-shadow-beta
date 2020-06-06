module Pages.Troubleshoot.View exposing (..)

import FontAwesome
import Html exposing (Html)
import Html.Attributes exposing (..)
import Libs.Tailwind as TW
import Pages.Troubleshoot.Data as Data
import Pages.Troubleshoot.Update exposing (Model, Msg(..))
import String.Extra as String
import Template.Elements exposing (..)
import Template.Section as Section


view : Model -> List (Html Msg)
view model =
    [ case (model.isLoading, model.uid, model.configuration) of
        (True, _, _) ->
            Section.section
                { title = "Loading"
                , body = []
                }

        (False, Just uid, Just config) ->
            summary uid config

        (False, Just _, Nothing) ->
            Section.section
                { title = "Not found"
                , body = []
                }

        (False, Nothing, _) ->
            Section.section
                { title = "Execute the following command"
                , body = []
                }
    ]


summary : String -> Data.Configuration -> Html Msg
summary uid config =
    Section.section
        { title = "Troubleshoot"
        , body =
            [ div [ TW.wFull, TW.textCenter ]
                [ a [ href ("/hostbin/" ++ uid) ] [ text "Raw data" ]
                ]
            , div [ TW.flex, TW.flexCol, TW.mdFlexRow, TW.itemsCenter, TW.justifyCenter ]
                [ div [ TW.w2over3, TW.mdW1over3, TW.p4 ]
                    [ img [ src (Data.getDistributionImage config.distribution) ] []
                    ]
                , div [ TW.wAuto, TW.p4 ]
                    [ table [ TW.borderNone ] <|
                        List.append
                            (List.map summaryItem <|
                                [ ( "Base distribution", config.baseDistribution )
                                , ( "Distribution version", config.distributionVersion )
                                , ( "Kernel version", config.kernel )
                                , ( "Environment", config.environment )
                                , ( "CPU", config.cpu )
                                , ( "GPU", config.gpu )
                                , ( "VA Driver", config.vaDriver )
                                ]
                            )
                            (List.map summaryBoolItem <|
                                [ ( "H264", config.isH264Supported )
                                , ( "H265", config.isH265Supported )
                                ]
                            )
                    ]
                ]
            ]
        }


summaryItem : ( String, Maybe String ) -> Html Msg
summaryItem ( label, value ) =
    tr []
        [ summaryTd [ TW.w48 ]
            [ strong [] [ text (label ++ ":") ]
            ]
        , summaryTd []
            [ text <|
                String.toSentenceCase (value |> Maybe.withDefault "Undefined")
            ]
        ]


summaryBoolItem : ( String, Bool ) -> Html Msg
summaryBoolItem ( label, value ) =
    tr []
        [ summaryTd [ TW.w48 ]
            [ strong [] [ text (label ++ ":") ]
            ]
        , summaryTd []
            [ FontAwesome.icon <|
                if value then
                    FontAwesome.check

                else
                    FontAwesome.times
            ]
        ]


summaryTd : List (Html.Attribute Msg) -> List (Html Msg) -> Html Msg
summaryTd attributes =
    td
        (attributes
            |> (::) TW.borderNone
        )
