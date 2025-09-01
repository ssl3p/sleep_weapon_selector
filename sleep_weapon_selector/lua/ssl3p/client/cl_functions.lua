function SSL3P:RX(x)
    return x / 1920 * ScrW()
end

function SSL3P:RY(y)
    return y / 1080 * ScrH()
end

function SSL3P:Font(iSize, sFont, iWeight)

    sFont = sFont or "Medium"
    iSize = iSize or 25
    iWeight = iWeight or 500
    
    local sName = ("SSL3P:Font:"..sFont..":"..tostring(iSize))
	if not SSL3P:GetFont(sFont) then return end

    if not SSL3P.Fonts[sName] then
        
        surface.CreateFont(sName, {
            font = "Montserrat "..sFont,
            extended = false,
            size = SSL3P:RX(iSize),
            weight = iWeight
        })

        SSL3P.Fonts[sName] = true

    end

    return sName

end