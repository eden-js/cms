<cms-placement>
  <div class="cms-placement placement-{ opts.placement.split('.').join('-') }">
    <div class="cms-placement-blocks" data-placement={ opts.placement } data-is="eden-blocks" blocks={ this.getBlocks() } placement={ getPlacement() } on-save={ onSave } position={ opts.placement } />
  </div>
  
  <script>
    // mixin acl
    this.mixin('acl');
    this.mixin('model');
    
    // is update
    this.isUpdate = false;
    
    /**
     * on save placements
     *
     * @return {Model}
     */
    onSave (placement) {
      // get placements
      let placements = this.eden.get('placements') || {};
        
      // set placement
      placements[opts.placement] = placement.get();
      
      // set placements
      this.eden.set('placements', placements);
    }

    /**
     * on update name
     *
     * @param  {Event} e
     */
    onToggleUpdate (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set update
      this.isUpdate = !this.isUpdate;

      // update
      this.update();
    }
    
    /**
     * gets blocks
     *
     * @return {Array}
     */
    getBlocks () {
      // check for blocks
      return this.eden.get('blocks') || [];
    }
    
    /**
     * returns placement
     *
     * @return {Object}
     */
    getPlacement () {
      // return placement
      return (this.eden.get('placements') || {})[opts.placement] ? this.eden.get('placements')[opts.placement] : {
        'position' : opts.placement
      };
    }
    
  </script>
</cms-placement>
