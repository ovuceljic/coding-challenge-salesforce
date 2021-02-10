import { LightningElement, wire, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getStagingProductDetails from '@salesforce/apex/ProductDetailController.getStagingProductDetails';

export default class ProductDetailLightningWebComponent extends LightningElement {
    @api recordId;
    @wire (getRecord, {
        recordId:'$recordId',
        fields:[
            'Product2.Name', 
            'Product2.GTIN__c', 
            'Product2.Purchasing_Price__c', 
            'Product2.Selling_Price__c',
            'Product2.Margin__c'
        ]
    })
    product;

    @wire(getStagingProductDetails, {productId: '$recordId'})
    stagingProducts;
    
}