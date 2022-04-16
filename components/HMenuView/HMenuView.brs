
sub Init()
    m.buttons = m.top.findNode("menuButtonGroup")
    m.top.viewContentGroup.appendChild(m.buttons)
    m.top.observeField("focusedChild","onChildFocused")
    examplerect = m.buttons.boundingRect()
    centerx = (1280 - m.viewOffsetX - examplerect.width) / 2
    centery = (720 - m.viewOffsetY - m.defaultOverhangHeight - examplerect.height) / 3
    m.buttons.translation = [ centerx, centery ]
end sub


sub onChildFocused()
    if m.top.isInFocusChain() and not m.buttons.hasFocus() then
       m.buttons.setFocus(true)
    end if 
end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    return handled
end function
