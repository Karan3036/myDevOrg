public class XMLFeedGenerator {
    public String recordID;
    public String xmlstring { get; set; }

    public XMLFeedGenerator() {
        recordID = ApexPages.currentPage().getParameters().get('Id').escapeHtml4();
        List<String> fieldNames = getFieldNamesFromFieldSet('Account', 'XMLFeedField');
        System.debug('Field Names: ' + fieldNames);

        DOM.Document doc = new DOM.Document();
        dom.XmlNode rootNode = doc.createRootElement('records', null, null);

        String query = generateDynamicQuery(fieldNames);

        List<SObject> records = Database.query(query);

        for (SObject record : records) {
            dom.XmlNode recordNode = rootNode.addChildElement(record.getSObjectType().getDescribe().getName(), null, null);

            for (String fieldName : fieldNames) {
                Object fieldValue = record.get(fieldName);

                // Check for null before adding text node
                if (fieldValue != null) {
                    recordNode.addChildElement(fieldName, null, null).addTextNode(String.valueOf(fieldValue));
                } else {
                    // Handle null values as needed
                    recordNode.addChildElement(fieldName, null, null).addTextNode('NULL');
                }
            }
        }

        xmlstring = doc.toXmlString();
        System.debug('xmlstring-->' + xmlstring);
    }

    public List<String> getFieldNamesFromFieldSet(String objectApiName, String fieldSetName) {
        List<String> fieldNames = new List<String>();

        try {
            // Retrieve the SObjectType for the given object API name
            Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectApiName);
            if (objectType != null) {
                // Get the fieldset map for the given object type
                Map<String, Schema.FieldSet> fieldSetMap = objectType.getDescribe().fieldSets.getMap();

                // Check if the fieldset with the given name exists
                if (fieldSetMap.containsKey(fieldSetName)) {
                    // Get the fields from the fieldset
                    List<Schema.FieldSetMember> fieldSetMembers = fieldSetMap.get(fieldSetName).getFields();

                    // Extract field names and add them to the list
                    for (Schema.FieldSetMember fieldSetMember : fieldSetMembers) {
                        fieldNames.add(fieldSetMember.getFieldPath());
                    }
                }
            }
        } catch (Exception e) {
            // Handle exceptions as needed
            System.debug('Exception: ' + e.getMessage());
        }

        return fieldNames;
    }

    public String generateDynamicQuery(List<String> fieldNames) {
        String query = 'SELECT Id';

        for (String fieldName : fieldNames) {
            query += ', ' + fieldName;
        }

        query += ' FROM Account WHERE Id = :recordID LIMIT 1';

        return query;
    }
}
