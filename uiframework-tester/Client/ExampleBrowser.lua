GlobalDialogs = {}
ExampleBrowserDialog = nil

function CreateExBrowser()
    -- UIFramework Logo Style
    local ImageStyle = UICSS()
    ImageStyle['left'] = "10px"
    ImageStyle['width'] = "400px"
    ImageStyle['top'] = "10px"
    ImageStyle['height'] = "100px"

    -- UIFrameworkLogo
    local uiFrameworkLogo = UIImage()
    uiFrameworkLogo.mode("contain")
    uiFrameworkLogo.setCSS(ImageStyle)
    --uiFrameworkLogo.appendTo(UIFramework)
    uiFrameworkLogo.setImage("package://" .. Package.GetName() .. "/Client/resources/UIFrameworkLogo.png")


    -- set position to right bottom for the help
    local helpStyle = UICSS()
    helpStyle['position'] = "absolute"
    helpStyle['right'] = "20px"
    helpStyle['bottom'] = "20px"

    --Create a text
    local help = UIText()
    help.setContent([[
        <h1>Info</h1>
        Press the key 'I' to toggle the example dialog visibility. <br>
        Press the key 'O' to toggle the debug console visibility.
    ]])
    help.setCSS(helpStyle)
    help.appendTo(UIFramework)




    --Set dialog size and position
    --[[
    local dialogPosition = UICSS()
    dialogPosition.top = "250px"
    dialogPosition.left = math.floor((Viewport.GetViewportSize().X - 600) / 2) .. "px !important"
    dialogPosition.width = "600px"
    ]]--

    local dialogPosition = UICSS()
    dialogPosition['top'] = "0px"
    dialogPosition['width'] = "350px"
    dialogPosition['left'] = (Viewport.GetViewportSize().X - 370).."px"
    dialogPosition['border-radius'] = "0px"

    local titleStyle = UICSS()
    titleStyle['position'] = "relative"
    titleStyle['border-radius'] = "0px"

    --Create a dialog
    local ExampleBrowserDialog = UIDialog()
    ExampleBrowserDialog.setTitle("Example Browser")
    ExampleBrowserDialog.setCSS(dialogPosition)
    ExampleBrowserDialog.setTitleCSS(titleStyle)
    ExampleBrowserDialog.appendTo(UIFramework)
    ExampleBrowserDialog.setCanClose(false)
    ExampleBrowserDialog.setMovable(false)
    ExampleBrowserDialog.onClickClose(function(obj)
        obj.hide()
    end)

    --Create a text
    local desc = UIText()
    desc.setContent("Press the key 'I' to toggle between UI and Game input or J to hide all Dialogs")
    desc.appendTo(ExampleBrowserDialog)

    --Create a text
    local title = UIText()
    title.setContent("Please select a dialog to show or hide")
    title.appendTo(ExampleBrowserDialog)

    --Create a option list
    local selectedDialogs = nil
    local dialogList = UIOptionList()
    dialogList.allowMultiselection(true)
    dialogList.appendOption("OptionList");
    dialogList.appendOption("WelcomeDialog");
    dialogList.appendOption("DialogExample");
    dialogList.appendOption("ColorPicker");

    dialogList.appendTo(ExampleBrowserDialog)
    dialogList.onChange(function(obj)
        --print("obj.getValue()", NanosUtils.Dump(obj.getValue()))
        selectedDialogs = obj.getValue()
    end)

    --Container to show the buttons horizontal and not vertical
    local buttonContainer = UIContainer()
    buttonContainer.setDirection("horizontal")
    buttonContainer.appendTo(ExampleBrowserDialog)


    --Create the "hide" button
    local showButton = UIButton()
    showButton.setTitle("Show dialog")
    showButton.setType("primary")
    showButton.onClick(function(obj)
        for _, value in pairs(selectedDialogs) do
            local dialog = GlobalDialogs[value]
            --print(dialog)
            if dialog ~= nil then
                dialog.show()
                --center the dialog
                dialog.setToScreenCenter()
            end
        end
    end)
    showButton.appendTo(buttonContainer)

    --Create the "show" button
    local hideButton = UIButton()
    hideButton.setTitle("Hide dialog")
    hideButton.setType("secondary")
    hideButton.onClick(function(obj)
        for _, value in pairs(selectedDialogs) do
            local dialog = GlobalDialogs[value]
            if dialog ~= nil then
                dialog.hide()
            end
        end
    end)
    hideButton.appendTo(buttonContainer)
end

Package.Subscribe("Load", function()
    CreateExBrowser()
end)

-- press key to toggle between UI or GAME Input 
local interfaceActive = false

function toggleUIMode()
    interfaceActive = not interfaceActive

    Input.SetMouseEnabled(interfaceActive)

    if interfaceActive == true then
        if ExampleBrowserDialog ~= nil then
            ExampleBrowserDialog.show()
        end
    else
        if ExampleBrowserDialog ~= nil then
            ExampleBrowserDialog.hide()
        end
    end
end


Input.Subscribe("KeyPress", function(key, delta)
    if key == "I" then
        toggleUIMode()
	end

    if key == "J" then
        interfaceActive = false
        Input.SetMouseEnabled(false)

        if ExampleBrowserDialog ~= nil then
            ExampleBrowserDialog.hide()
        end
        for _,dialog in pairs(GlobalDialogs) do
            dialog.hide()
        end
    end
end)