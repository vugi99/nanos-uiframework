function UIRadioButton()
    local self = UIElement()

    self.options.template = [[
        <div id="<%- id %>" class="ui-framework-parent">Not yet available!</div>
    ]]

    return self
end
Package.Export("UIRadioButton", UIRadioButton)