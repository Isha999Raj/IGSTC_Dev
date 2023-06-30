import { api, LightningElement, wire, track } from 'lwc';
import getRecords from '@salesforce/apex/showSalesPathActionOnProposalController.getActionRecords';

export default class ShowSalesPathActionOnProposal extends LightningElement {
    @api recordId;
    @track listOfActions = [];

    @wire(getRecords,{propId:'$recordId'})
    wiredResponse(result){
        if(result.data){
            console.log('Data-------',result.data);
          
            this.listOfActions = result.data;
            
            // var itemList = [];
            // for(var i=0;i<this.listOfHeads.length;i++){
            //     var item = Object.assign({},this.listOfHeads[i]);

            //     item.index = i;
            //     itemList.push(item);
            // }
            
            // console.log(itemList);
            // this.listOfHeads = itemList;
            
        }else{
            console.log("Error to fetch data of Accounts",result);
        }
    }
}