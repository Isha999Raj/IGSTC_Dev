import { LightningElement, wire,track,api } from 'lwc';
	
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import updateSCStage from '@salesforce/apex/UtilityToUploadExcelAndUpdateController.updateSCStage';
import getAllProposals from '@salesforce/apex/UtilityToUploadExcelAndUpdateController.getAllProposals';
export default class UtilityToUploadExcelAndUpdate extends LightningElement {

    @track listOfHeads = [];
    @track isModalOpen = false;
    @track lengthOfRecords;
    @track approvedCount = 0;
    @track rejectedCount = 0;
    @track declinedCount = 0;
    @track waitlistedCount = 0;
    @wire(getAllProposals)
    wiredResponse({data,error}){
        debugger;
        if(data){
            debugger;
            console.log('Proposals Data-------',data);
            this.listOfHeads = data;
            
        }else{
            console.log("Error to fetch data of Proposals",error);
        }
    }

    file;
   handleInputChange(event){
    debugger;
    if(event.target.files.length > 0){
       
      //this.ligtningAlertOnUpload();
        this.file = event.target.files[0];
        this.read(this.file);

    };
   
    }

    async read(file) {
      debugger;
      try {
        const result = await this.load(file);
        
        this.parse(result);
      } catch (e) {
        this.error = e;
      }
    }

    async load(file) {
      debugger;
      return new Promise((resolve, reject) => {
        const reader = new FileReader();
  
        reader.onload = () => {
          resolve(reader.result);
        };
        reader.onerror = () => {
          reject(reader.error);
        };
        reader.readAsText(file);
      });
    }

    @track Csvdata=[];

    parse(csv) {
      debugger;
      const lines = csv.split(/\r\n|\n/);
      
      const headers = lines[0].split(',');
    
      const data = [];
      
      lines.forEach((line, i) => {
        debugger;
        
        if (i === 0) return;
        if(line == '') return;
        const obj = {};
        const currentline = line.split(',');
    
        for (let j = 0; j < headers.length; j++) {
          debugger;
          obj[headers[j]] = currentline[j];
        }
    
        data.push(obj);
        console.log('data=',JSON.stringify(data));
      });

      for(let i = 0; i < data.length; i++){
        debugger;
        if(data[i].SC_Review_Stages__c == 'Sc Review Approved'){
            this.approvedCount = this.approvedCount+1;
        }else if(data[i].SC_Review_Stages__c == 'SC Review Rejected'){
            this.rejectedCount = this.rejectedCount+1;
        }else if(data[i].SC_Review_Stages__c == 'SC Review Waitlisted'){
            this.waitlistedCount = this.waitlistedCount+1;
        }else if(data[i].SC_Review_Stages__c == 'SC Review Decline'){
            this.declinedCount = this.declinedCount+1;
        }
        if(this.listOfHeads.find(item=>item.Name==data[i].Name)){
            data[i].Id = this.listOfHeads.find(item=>item.Name==data[i].Name).Id;
             
        }
      }
      console.log('dataUpdated=',JSON.stringify(data));
        this.Csvdata=data;
        this.lengthOfRecords = data.length;
        console.log('lengthOfRecords=',lengthOfRecords);
      
    }

    handleSubmit() {
        console.log('data in Csvdata after onclick=',JSON.stringify(this.Csvdata));
        debugger;
        updateSCStage({myArray:this.Csvdata})
        .then(result=>{
           if(result=='SUCCESS'){
              this.dispatchEvent(
                 new ShowToastEvent({
                     title: 'Success',
                     message:'Stage has been updated successfully..',
                     variant:'success',
                 }),
                 this.isModalOpen = false
             );   
        }
        else {
            
           this.dispatchEvent(
              new ShowToastEvent({
                  title: 'error',
                  message:'error',
                  variant:'error',
              }),
              this.isModalOpen = false
          ); 
        }
       })
       .catch(error=>{
           window.alert(error);
           console.log('error in Comp=',error);
           
       })
      }
  
      ligtningAlertOnUpload(){
        LightningAlert.open({
          message: 'This is the alert message.',
          theme: 'Success', // a red theme intended for error states
          label: 'Uploading!', // this is the header text
      });
      }

    openModal() {
       this.isModalOpen = true;
    }
    closeModal() {
        this.isModalOpen = false;
    }
    submitDetails() {
        this.isModalOpen = false;
    }
}