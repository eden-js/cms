<block-view>
  <div class="card h-100">
  
    <div class="card-header">
      <yield from="header" />
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
    
  </script>
</block-view>
