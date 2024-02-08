({
    copyInputFieldValue : function(component, event, helper) {
        // get lightning:textarea field value using aura:id
        // var textForCopy = 'https://mvclouds36-dev-ed.develop.my.salesforce-sites.com/k1/XMLFeed?Id='+component.get("v.selectionCategory.Id");
        // var textForCopy = component.find('inputF').get('v.value');
        var outputElements = document.getElementsByClassName('output-holder');
        var outputElement;
        var outputValue;

        if (outputElements.length > 0) {
            outputElement = outputElements[0];
            outputValue = outputElement.value;

            console.log('In if-->',outputValue);
        } else {
            outputValue = 'https://mvclouds36-dev-ed.develop.my.salesforce-sites.com/k1/XMLFeed?Id='+component.get("v.selectionCategory.Id");
            console.error('In else-->',outputValue);
        }
        helper.copyTextHelper(component,event,outputValue);
    },
})
