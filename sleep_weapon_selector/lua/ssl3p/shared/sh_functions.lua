function SSL3P:GetConst(sTable, sName)
    return SSL3P.Constants[sTable or "cColors"][sName or "black_bg1"]
end

function SSL3P:GetFont(sName)
    return SSL3P.Constants["sFonts"][sName or "Bold"]
end