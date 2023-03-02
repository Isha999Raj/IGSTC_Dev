import { LightningElement, track,wire,api } from 'lwc';
import getFoldersAndFiles from '@salesforce/apex/filesAndDocsViewerLWCcontroller.getFoldersAndFiles'
import getSubFoldersAndFiles from '@salesforce/apex/filesAndDocsViewerLWCcontroller.getSubFoldersAndFiles';
import createFolderSP from '@salesforce/apex/filesAndDocsViewerLWCcontroller.createFolder';
import deleteFolderInsideSite from '@salesforce/apex/filesAndDocsViewerLWCcontroller.deleteFolderInsideSite';
import deleteFileSP from '@salesforce/apex/filesAndDocsViewerLWCcontroller.deleteFileSP';
import createFile from '@salesforce/apex/filesAndDocsViewerLWCcontroller.createFile';
import downloadFile from '@salesforce/apex/ProposalDocumentLWCController.downloadFile';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class FilesDocsViewer extends LightningElement {
    @api recordId;
    @track isLoaded = false;
    @track response;
   // @track folders = []
   @track fileData;
   @track parentId;
   @track folderSelected
   @track selectedFolder;
   @track isHomeActive;
    @track files = [];
    @track path = [{name:"Home",folders:[]}]
    @track showFolderCreation = false;
    @track showFileCreation = false;
    @track disableFolderDeletion = true;
    @track url = 'https://utillabs.sharepoint.com/sites/IGSTC/Shared%20Documents/Forms/AllItems.aspx?id=%2Fsites%2FIGSTC%2FShared%20Documents%2FProposals%2FIGSTC-00211%2F1st%20Year%2F2%2B2_Call_Template_-_a081y0000029hfO.pdf&parent=%2Fsites%2FIGSTC%2FShared%20Documents%2FProposals%2FIGSTC-00211%2F1st%20Year';
   


    connectedCallback(){
        getFoldersAndFiles({recId: this.recordId}).then(res=>{
            console.log('thisisData>>'+ JSON.stringify(res));
            this.response = res;
            let data = res;
            
            let folders= [];
            let tempFolder = [];
            this.isLoaded = true;
            this.response = data;
            console.log('Data-------',data);
            if(data.folders){
                tempFolder = [...data.folders];
                tempFolder.sort((a,b)=>a.Name.localeCompare(b.Name));
            }
            if(data.files){
                this.files = [...data.files];
                this.files.sort((a,b)=>a.Name.localeCompare(b.Name));
            }
            tempFolder.forEach(item=>{
                let obj = {...item};
                obj.expanded = false;
                obj.style="";
                obj.active = false;
               folders.push(obj);
            })

            console.log('ParentFolders-----x',folders)
  
            this.path[0].folders = folders;
            this.path[0].index = 0;
            this.selectedFolder = this.path[0];
            console.log('ParentFolders----',this.path);
            this.isHomeActive = true;
         console.log('path>>>'+ this.path);
        })
    }


    
    getFiles(){
        let folderId = this.selectedFolder.folderId;
        getSFFiles({folderId}).then(result=>{
            console.log('Files fetched-----',result);

            let filesList = Object.keys(result).map(item=>({
                "label":result[item],
                "value": item,
                "url":`/sfc/servlet.shepherd/document/download/${item}`,
                "style":'',
                "active":false
            }))

            this.selectedFolder.files = filesList;
        }).catch(error=>{
            console.log('Error to fetch files',error);
        })   
    }

    getFolders(){
       
        debugger;
        let lastIndex = this.path.length-1;
        if(lastIndex!=0){
            getFolders({parentFId:this.path[lastIndex].folderId}).then(result=>{
                console.log('Sub Folders-----',result);

                let folders = [];
                result.forEach(folder=>{
                    let obj = {...folder};
                    obj.active = false;
                    obj.style="";
                    folders.push(obj);
                })
                this.path[lastIndex].index = lastIndex;
                this.path[lastIndex].folders = folders;
                this.selectedFolder = this.path[lastIndex];

                console.log('Path----',this.path);
                this.getFiles();
            }).catch(error=>{
                console.log("Error to get sub Folders---",error);
            })
        }
    }


    getSPFolders(){
        console.log('SelectedFolders---',this.selectedFolder);

            let subFilesUrl = this.selectedFolder.fileUrl.split('https://utillabs.sharepoint.com/')[1];
            let subFoldersUrl = this.selectedFolder.folderUrl.split('https://utillabs.sharepoint.com/')[1];

        debugger;
        getSubFoldersAndFiles({filesUrl:subFilesUrl,foldersUrl:subFoldersUrl}).then(result=>{
            if(result.folders){
                debugger;
                let subFolderList = [];
                result.folders.forEach(item=>{
                    let obj = {...item};
                    obj.expanded = false;
                    subFolderList.push(obj);
                })
                debugger;
                //selectedFolder.subFolders = subFolderList;
                this.selectedFolder.folders = subFolderList;
                //this.path.push({name: doc.Name,folders:subFolderList,index:this.path.length,folderId:id,ServerRelativeUrl:doc.ServerRelativeUrl})
            //this.selectedFolder = this.path[this.path.length-1];
            //this.isHomeActive = this.path.length==1;
            debugger;
               
            }
      
                if(result.files){
                    let subFiles = [];
                    result.files.forEach(item=>{
                        let obj = {...item};
                        console.log('objis>>>>>>>'+ JSON.stringify(obj))
                        obj.clicked = false;
                        subFiles.push(obj);
                    })
                    this.selectedFolder.files = subFiles.sort((a,b)=>a.Name.localeCompare(b.Name));
                    
            }
            

            // this.folders[clickedIndex] = selectedFolder;
            // this.selectedParent = selectedFolder;
        })
    }
    
    
    @track isHomeActive = true;

    pathClicked(event){
        debugger;
        let rIndex = 0;
        let pathIndex = parseInt(event.currentTarget.dataset.index);

        rIndex = pathIndex;
        pathIndex = pathIndex==0?pathIndex+1:pathIndex;

        if(pathIndex!=this.path.length-1 || rIndex==0){ 
            
            this.fileDeletionDisable = true;
            this.folderDeletionDisable = true;
            this.isHomeActive = rIndex==0;
            pathIndex = rIndex!=0?pathIndex+1:pathIndex;

            this.path = this.path.slice(0,pathIndex);
            this.selectedFolder = this.path[rIndex];
            this.getFolders();
        }
    }


    @track folderDeletionDisable = true;

    onFolderSingleClick(event){

        let id = event.currentTarget.dataset.id;
           console.log('id' + id);
    
        if(this.path.length!=1){
            this.selectedFolder.folders.forEach(folder=>{
         
          console.log('UniqueIdis>>>>>> '+  folder.UniqueId+ ' Name is>>>' + folder.Name)
          
                folder.active = folder.UniqueId == id;
                    
                folder.style = folder.active?'color:blue':'';
                console.log('folder'+ folder);
           
                if(folder.active){
                    this.folderDeletionDisable = false;
                }
            })
        }
    }



    folderClicked(event){
        debugger;

        this.selectedParent = null;
        this.selectedSubFolder = null;
        this.disableFolderDeletion = true;
        this.disableFileClicked = true;
        this.selectedFile = null;
        
        let id = event.currentTarget.dataset.id;
        this.parentId = id;
        let doc = this.selectedFolder.folders.find(item=>item.UniqueId==id);

        let folderId = event.currentTarget.dataset.id;
        let clickedIndex =  this.selectedFolder.folders.findIndex(item=>item.UniqueId==folderId);
        console.log('id' + id);
        let foldersList = [];
        this.selectedFolder.folders.forEach(item=>{
            let obj = {...item};
            if(obj.UniqueId!=folderId){
                obj.expanded = false;
                obj.active = false;
            }
            foldersList.push(obj);
        })

        this.selectedFolder.folders = foldersList;
        this.selectedFolder.folders[clickedIndex].active = !this.selectedFolder.folders[clickedIndex].active;

        console.log('ProposalCliecked',this.selectedFolder.folders[clickedIndex]);

        let selectedFolder =this.selectedFolder.folders[clickedIndex];

            let subFilesUrl = selectedFolder.Files.__deferred.uri.split('https://utillabs.sharepoint.com/')[1];
            let subFoldersUrl = selectedFolder.Folders.__deferred.uri.split('https://utillabs.sharepoint.com/')[1];

            debugger;
            getSubFoldersAndFiles({filesUrl:subFilesUrl,foldersUrl:subFoldersUrl}).then(result=>{
                if(result.folders){
                    debugger;
                    let subFolderList = [];
                    result.folders.forEach(item=>{
                        let obj = {...item};
                        obj.expanded = false;
                        subFolderList.push(obj);
                    })
                    debugger;
                    selectedFolder.subFolders = subFolderList;
                    
                    let fileUrl = doc.Files.__deferred.uri;
                    let folderUrl = doc.Folders.__deferred.uri;
                    this.path.push({name: doc.Name,folders:subFolderList,index:this.path.length,folderId:id,ServerRelativeUrl:doc.ServerRelativeUrl,fileUrl:fileUrl,folderUrl:folderUrl })
                this.selectedFolder = this.path[this.path.length-1];
              this.isHomeActive = this.path.length==1;
             
                debugger;
                   
                }
                //if(!this.isHomeActive){
                    if(result.files){
                        let subFiles = [];
                        result.files.forEach(item=>{
                            let obj = {...item};
                           // console.log('objis>>>>>>>', objobj.UniqueId)
                            

                            obj.clicked = false;
                            subFiles.push(obj);
                        })
                        this.selectedFolder.files = subFiles.sort((a,b)=>a.Name.localeCompare(b.Name));
                        
                }
         
            })
        
        
       

        
    }


    @track showFileCreation = false;
    showFileCreationHandler(){
        this.showFileCreation = true;
    }

    closeFileCreation(){
        this.showFileCreation = false;
    }


    @track disableFileCreation = true;
  @track newFile;
    fileSelectedHandler(event){
        debugger;

        let file = event.target.files[0];
        let temp = this;
      this.fileData=file;
        this.newFile = file;
        this.disableFileCreation = false;

    }


    @track isFileUploading = false;
   
    createFileSP(){
        debugger;
        let file = this.fileData;
        let reader = new FileReader();
        let temp = this
        console.log('SelectedParent----',temp);
        console.log('selectedFolder--------',this.selectedFolder);

        reader.onload = function() {
           

            debugger;

            let base64 = this.result.split(/,/)[1];
            let fileName = file.name.replaceAll(' ','_');
            let path;
            
            console.log('SelectedParent----',temp.selectedParent);

            if(temp.selectedFolder){
                path = temp.selectedFolder.ServerRelativeUrl.replaceAll(' ','%20');
            }else{
                path = temp.selectedParent.ServerRelativeUrl.replaceAll(' ','%20');
            }


            console.log('ContentType---',path);

            createFile({base64,fileName,path}).then(res=>{
               
         this.showFileCreation = false;
             
                debugger;
      
                this.fileData = null
               
                this.isFileUploading = false;
               
                debugger;
               
                console.log('FileCreation'+temp.showFileCreation);
              
                temp.showFileCreation = false;
                temp.showNotification('Success',`${fileName} is uploaded Succesfully`,'success');
                temp.getSPFolders();
                
            }).catch(error=>{
                temp.showNotification('Error',error,'error');
                console.log('Error to create the file----',error);
            }) 
            this.showFileCreation = false;
        }

        reader.readAsDataURL(file)

     
       
    }


    showNotification(title,message,variant){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

    onFileDBClicked(event){
        console.log(event.currentTarget.dataset.id)
        this[NavigationMixin.Navigate]({ 
            type:'standard__namedPage',
            attributes:{ 
                pageName:'filePreview'
            },
            state:{ 
                selectedRecordId: event.currentTarget.dataset.id
            }
        })
    }

    @track fileDeletionDisable = true;
    onFileSingleClick(event){
      
        debugger;
        let fileId = event.currentTarget.dataset.id;
      
         if(this.path.length!=1){
           
        this.selectedFolder.files.forEach(file=>{
              
            if(file.UniqueId == fileId){
            file.active = true;
            file.value ==file.UniqueId;
            file.style = file.active?'color:blue':'';
            }else{
                file.style=''
                file.active = false;
            }
            if(file.active){
                this.fileDeletionDisable = false;
            }
        })
        console.log('files are ----->',this.selectedFolder.files);
        }


    }


    @track showFolderCreation = false;
    showFolderCreationPopup(){
        this.showFolderCreation = true;
    }

    closeFolderCreation(){
        this.showFolderCreation = false;
        this.folderName = '';
    }

    @track disableCreate = true;
    @track folderName = '';
    inputHandler(event){
        this.folderName = event.target.value;
        if(!this.folderName || this.folderName.length==0){
            this.disableCreate = true;
        }else{
            this.disableCreate = false;
        }
    }
    createFolder(){

        if(!this.folderName || this.folderName.length==0){
            this.showNotification('Failed','Please enter the folder name','error');
            return;
        }
        this.isFileUploading = true;

        let path = this.selectedFolder.ServerRelativeUrl.replaceAll(' ','%20');
        createFolderSP({path:`${path+'/'+this.folderName}`}).then(result=>{
            this.getSPFolders();
            //this.getFolders();
            this.showFolderCreation = false;
            this.showNotification('Succesfully',`${this.folderName} folder is created.`,'success');
            this.folderName = '';
            this.isFileUploading = false;
        }).catch(error=>{
            this.showFolderCreation = false;
            console.log('Error----',error);
        })   
        // createSFFolder({parentFId:this.selectedFolder.folderId,folderName:this.folderName}).then(result=>{
        //     if(result=='Success'){
        //         this.isFileUploading = false;
        //         this.folderName = '';
        //         this.showFolderCreation = false;
        //         this.showNotification('Success',`${this.folderName} folder created!`,'success');
        //         this.getFolders();   
        //     }
        // }).catch(error=>{
        //     console.log('Error to create folder---',error);
        // })
    }
    deleteFiles(){
        debugger;
        let selectedFolderToDelete = this.selectedFolder.files.find(item=>item.active);
        this.isLoading = true;
        let path = selectedFolderToDelete.ServerRelativeUrl;
        console.log('Path---',path);
        deleteFileSP({path}).then(result=>{
       debugger;
            console.log('File deletion result---',result);
            this.fileDeletionDisable = true;
            this.isLoading = false;
            this.showNotification('Success','File deleted Succesfully!','success');
            this.getSPFolders();
        }).catch(error=>{
            console.log('Error to delete the file---',error);
            this.showNotification('Error',error,'error');
        })
    }
    deleteFolders(){
        debugger;
                    console.log('serverurl-----', this.selectedFolder);
                    let selectedFolderToDelete = this.selectedFolder.folders.find(item=>item.active);
                    if(!selectedFolderToDelete){
                        this.showNotification('Error','Please select any folder to delete','error');
                    }

                    deleteFolderInsideSite({path:selectedFolderToDelete.ServerRelativeUrl}).then(result=>{
                        if(result=='Success'){
                            this.showNotification('Success',`${this.selectedFolder.Name} folder deleted succesfully`,'success');
                            debugger;
                            this.selectedFolder.folders = this.selectedFolder.folders.filter(item=>!item.active);
                            //this.folders[parentIndex].subFolders = this.folders[parentIndex].subFolders.filter(item=>item.UniqueId!=this.selectedSubFolder.UniqueId);
                            this.folderDeletionDisable = true;
                        }
                    }).catch(error=>{
                        console.log(error.message)
                        console.log('Error to delete subfolder')
                    })

                    // this.selectedFolder.folder.forEach(item=>{
                    //     if(item.active==true){
                    //         selectedFolderToDelete= item;
                    //     }
                    // })
                    console.log('selectedFolderToDelete>>>', selectedFolderToDelete);
          //  let childIndex = this.folders[parentIndex].subFolders.findIndex(item=>item.UniqueId==this.selectedSubFolder.UniqueId);
        
        }
    }