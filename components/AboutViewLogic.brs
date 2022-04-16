sub ShowAboutView()
    m.rect = CreateObject("roSGNode", "HTextView")
    m.rect.callFunc("setText", ReadASCIIFile("pkg:/data/about.txt"))
    m.top.ComponentController.CallFunc("show", {
        view: m.rect
    })
end sub
