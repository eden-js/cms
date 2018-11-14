<block>
  <div class="card h-100">
  
    <div class="card-header">
      <div class="row row-eq-height">
        <div class="col-8 d-flex align-items-center">
          <div class="w-100">
            <yield from="header" />
          </div>
        </div>
        <div class="col-4 d-flex align-items-center">
          <div class="w-100">
            <div class="btn-group float-right">
              <yield from="buttons" />
              <button class="btn btn-sm btn-primary" onclick={ onRefresh }>
                <i class={ 'fa fa-sync' : true, 'fa-spin' : this.refreshing || opts.block.refreshing } />
              </button>
              <button class="btn btn-sm btn-info" data-toggle="modal" data-target="#block-{ opts.block.uuid }-update">
                <i class="fa fa-pencil" />
              </button>
              <button class="btn btn-sm btn-danger" onclick={ onRemove }>
                <i class={ 'fa fa-times' : true, 'fa-spin' : this.removing || opts.block.removing } />
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <yield from="body" />
    
    <yield from="footer" />
  </div>
  
  <div class="modal fade" id="block-{ opts.block.uuid }-update" tabindex="-1" role="dialog" aria-labelledby="block-{ opts.block.uuid }-label" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="exampleModalLabel">
            Update Block
          </h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label>
              Block Class
            </label>
            <input class="form-control" ref="class" value={ opts.data.class } onchange={ onClass } />
          </div>
          <yield from="modal" />
        </div>
      </div>
    </div>
  </div>
  
  <script>
    // set variables
    this.loading = {};
    this.updating = {};
      
    /**
     * on class
    
     * @param  {Event} e
     */
    async onClass (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();
      
      // set class
      opts.data.class = e.target.value.length ? e.target.value : null;

      // run opts
      if (opts.onSave) await opts.onSave(opts.block, opts.data);
    }
  
    /**
     * on refresh
     *
     * @param  {Event} e
     */
    async onRefresh (e) {
      // set refreshing
      this.refreshing = true;
      
      // update view
      this.update();

      // run opts
      if (opts.onRefresh) await opts.onRefresh(opts.block, opts.data);
      
      // set refreshing
      this.refreshing = false;
      
      // update view
      this.update();
    }
  
    /**
     * on refresh
     *
     * @param  {Event} e
     */
    async onRemove (e) {
      // set refreshing
      this.removing = true;
      
      // update view
      this.update();
      
      console.log(opts);

      // run opts
      if (opts.onRemove) await opts.onRemove(opts.block, opts.data);
      
      // set refreshing
      this.removing = false;
      
      // update view
      this.update();
    }
    
  </script>
</block>
