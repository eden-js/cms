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
            <button class="btn btn-sm btn-danger float-right" onclick={ onRemove }>
              <i class={ 'fa fa-times' : true, 'fa-spin' : this.removing || opts.block.removing } />
            </button>
            <button class="btn btn-sm btn-primary float-right mr-2" onclick={ onRefresh }>
              <i class={ 'fa fa-sync' : true, 'fa-spin' : this.refreshing || opts.block.refreshing } />
            </button>
          </div>
        </div>
      </div>
    </div>
    
    <yield from="body" />
    
    <yield from="footer" />
  </div>
  
  <script>
    // set variables
    this.loading = {};
    this.updating = {};
  
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
