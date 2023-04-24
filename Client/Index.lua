local AllUIFrameworkElements = {}

function AddUIFrameworkElement(e)
    table.insert(AllUIFrameworkElements, e)
end

function RemoveUIFrameworkElement(e)
    for i, v in ipairs(AllUIFrameworkElements) do
        if v.options.id == e.options.id then
            --AddPlayerChat("REMOVED ELEMENT")
            table.remove(AllUIFrameworkElements, i)
            break
        end
    end
end

function GetAllFrameworkElements()
    local tbl = {}
    for i, v in ipairs(AllUIFrameworkElements) do
        table.insert(tbl, v)
    end
    return tbl
end


local function UIFrameworkBase()
    local self = {
        id = "screen"
    }

    self.webui = WebUI(
        "UIFramework",
        "file://ui/hud.html",
        WidgetVisibility.Visible
    )
    --SetWebAnchors(ui, 0, 0, 1, 1)
    --SetWebAlignment(ui, 0, 0)
    self.webui:SetLayout(Vector2D(0, 0), Vector2D(0, 0), Vector2D(0, 0), Vector2D(1, 1), Vector2D(0, 0))

    local CallJavaScriptWaitQueue = {}
    local loaded = 0


    local children = {}
    local private = {
        notifications = {},
        scale = 1
    }

    -- create a unique ID
    local counter = 0;
    function self.getNewID()
        counter = counter + 1
        return counter;
    end

    -- todo: notifications on the main screen
    function self.sendNotification(notification)
    end

    function self.execute(javascript)
        if (loaded >= 2) then
            self.webui:ExecuteJavaScript(javascript)
        else
            table.insert(CallJavaScriptWaitQueue, javascript)
        end
    end

    local function ExecQueuedJavaScript()
        for i, v in ipairs(CallJavaScriptWaitQueue) do
            self.execute(v)
        end
        CallJavaScriptWaitQueue = {}
    end

    local function UIFrameworkLoadingPart()
        loaded = loaded + 1
        if loaded == 2 then
            ExecQueuedJavaScript()
        end
    end
    self.webui:Subscribe("Ready", UIFrameworkLoadingPart)
    self.webui:Subscribe("OnUIFrameworkReady", UIFrameworkLoadingPart)

    function self.appendChild(child)
        table.insert(children, child)
        child.options.parent = "screen"
        return self
    end

    function self.setScale(scale)
        private.scale = scale
    end

    function self.getScale()
            return private.scale
        end

    function self.show()
    end

    function self.hide()
    end

    function self.toggleVisibility()
    end

    function self.isVisible()
    end


    return self
end

function split_uif(str,sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    str:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

Package.Export("UIFramework", UIFrameworkBase())

Package.Require("UIElement.lua")
Package.Require("UINotification.lua")
Package.Require("UIDialog.lua")
Package.Require("UIButton.lua")
Package.Require("UIGrid.lua")
Package.Require("UITextField.lua")
Package.Require("UIContainer.lua")
Package.Require("UIListView.lua")
Package.Require("UIAccordion.lua")
Package.Require("UIText.lua")
Package.Require("UIProgressBar.lua")
Package.Require("UITabs.lua")
Package.Require("UICheckBox.lua")
Package.Require("UIImage.lua")
Package.Require("UIOptionList.lua")
Package.Require("UICSS.lua")
Package.Require("UIColorPicker.lua")
Package.Require("UISlider.lua")
Package.Require("UIAccordion.lua")