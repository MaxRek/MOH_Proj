using GeoJSON, DataFrames, CSV

function parseData(path :: String)

    dfS = Vector{DataFrame}()
    dfInfoS = Vector{DataFrame}()

    df = DataFrame(GeoJSON.read(String(path*"mapNiv2.geojson")))
    df = select(df,Not(11))
    push!(dfS, select(df, 1))
    push!(dfInfoS, select(df, Not(1)))
    
    df = DataFrame(GeoJSON.read(String(path*"mapNiv1.geojson")))

    push!(dfS, select(df, 1))
    push!(dfInfoS, select(df, Not(1)))

    df = CSV.read(String(path*"imb_nte_propre-coordunifor.csv"),DataFrame)
    push!(dfS, select(df, [:X, :Y, :xcoord, :ycoord]))
    push!(dfInfoS, select(df, [:imb_nbr_logloc,:imb_type,:addr_numero,:addr_nom_voie]))


    return dfS, dfInfoS
end