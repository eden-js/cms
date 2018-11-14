<block-modal>
  <div class="modal fade" id="block-modal" tabindex="-1" role="dialog" aria-labelledby="block-modal-label" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="block-modal-label">
            Select Block
          </h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <ul class="list-group">
            <li each={ block, i in getBlocks() || [] } class={ 'list-group-item list-group-item-action flex-column align-items-start' : true, 'active' : isActive(block) } onclick={ onBlock }>
              <div class="d-flex w-100 justify-content-between">
                <h5 class="mb-1">
                  { block.opts.title }
                </h5>
              </div>
              <p class="m-0">{ block.opts.description }</p>
            </li>
          </ul>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
          <button type="button" class={ 'btn btn-primary' : true, 'disabled' : !this.type || this.loading } disabled={ !this.type || this.loading } onclick={ onAddBlock }>
            { this.loading ? 'Adding block...' : (this.type ? 'Add block' : 'Select block') }
          </button>
        </div>
      </div>
    </div>
  </div>
  
  <script>
  
    /**
     * gets blocks
     *
     * @return {*}
     */
    getBlocks () {
      // return sorted blocks
      return opts.blocks.sort((a, b) => {
        // Return sort
        return ('' + a.opts.title).localeCompare(b.opts.title);
      });
    }
    
    /**
     * on block
     *
     * @param  {Event} e
     */
    onBlock (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();
      
      // activate block
      this.type = e.item.block.type;
      
      // update view
      this.update();
    }

    /**
     * on block
     *
     * @param  {Event} e
     */
    async onAddBlock (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();
      
      // set loading
      this.loading = true;
      
      // update view
      this.update();
      
      // add block by type
      await opts.addBlock(this.type);
      
      // set loading
      this.type    = null;
      this.loading = false;
      
      // update view
      this.update();
      
      // close modal
      jQuery('#block-modal').modal('hide');
    }
    
    /**
     * on is active
     *
     * @param  {Object}  block
     *
     * @return {Boolean}
     */
    isActive (block) {
      // return type
      return this.type === block.type;
    }
    
  </script>
</block-modal>
