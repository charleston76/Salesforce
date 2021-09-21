import { LightningElement, api, track } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import readCSV from '@salesforce/apex/LWCExampleController.readCSVFile';

const columns = [
    { label: 'Name', fieldName: 'Name' }, 
    { label: 'Industry', fieldName: 'Industry' },
    { label: 'Rating', fieldName: 'Rating'}, 
    { label: 'Type', fieldName: 'Type'}, 
    { label: 'Website', fieldName: 'Website', type:'url'}
];


export default class uploadProdutos extends LightningElement {
    @api recordId;
    @track error;
    @track columns = columns;
    @track data;
    get acceptedFormats() {
        return ['.xlsx', '.csv'];
    }
    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        let uploadedFileNames = '';
        for(let i = 0; i < uploadedFiles.length; i++) {
            uploadedFileNames += uploadedFiles[i].name + ', ';
        }
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: uploadedFiles.length + ' Files uploaded Successfully: ' + uploadedFileNames,
                variant: 'success',
            }),
            readCSV({idContentDocument : uploadedFiles[0].documentId})
            .then(result => {
                window.console.log('result ===> '+result);
                this.data = result;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success!!',
                        message: 'Accounts are created based CSV file!!!',
                        variant: 'success',
                    }),
                );
            })
            .catch(error => {
                this.error = error;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error!!',
                        message: JSON.stringify(error),
                        variant: 'error',
                    }),
                );     
            })
        );
    }
}