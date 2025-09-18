function SSL3P:GetConst(sTable, sName)
    return SSL3P.Constants[sTable or "cColors"][sName or "black_bg1"]
end

function SSL3P:GetFont(sName)
    local constants = SSL3P and SSL3P.Constants
    if not constants then return nil end
    local fonts = constants["sFonts"]
    if not fonts then return nil end
    return fonts[sName or "Bold"]
end