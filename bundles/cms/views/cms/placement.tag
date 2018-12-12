<cms-placement>
  <div class="cms-placement placement-{ opts.placement.split('.').join('-') }">
    <div class="cms-placement-update" if={ this.acl.validate('admin') }>
      <div class="row">
        <div class="col-8 d-flex align-items-center">
          <div class="w-100">
            Placement "{ opts.placement }"
          </div>
        </div>
        <div class="col-4 d-flex align-items-center">
          <div class="w-100 text-right">
            <button class="btn btn-sm mr-3 btn-primary" data-toggle="modal" data-target="#block-modal">
              Add Block
            </button>
          </div>
        </div>
      </div>
    </div>
    <div class="cms-placement-blocks" data-placement={ opts.placement } data-is="eden-blocks" blocks={ this.getBlocks() } placement={ getPlacement() } on-save={ onSave } position={ opts.placement } />
  </div>
  
  <script>
    // mixin acl
    this.mixin('acl');
    this.mixin('model');
    
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
