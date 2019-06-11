<cms-placement>
  <div class="cms-placement placement-{ opts.placement.split('.').join('-') }">
    <div class="cms-placement-blocks" data-placement={ opts.placement } ref="blocks" data-is="eden-blocks" blocks={ this.getBlocks() } placement={ getPlacement() } on-save={ onSave } position={ opts.placement } preview={ typeof opts.preview !== 'undefined' ? opts.preview : !this.acl.validate('admin') } />
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
    onSave(placement) {
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
    onToggleUpdate(e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set update
      this.isUpdate = !this.isUpdate;

      // update
      this.update();
    }

    /**
     * add load blocks function
     *
     * @return {*}
     */
    loadBlocks() {
      // return internal proxied
      return this.refs.blocks.loadBlocks(...arguments);
    }

    /**
     * gets blocks
     *
     * @return {Array}
     */
    getBlocks() {
      // check for blocks
      return opts.blocks || this.eden.get('blocks') || [];
    }

    /**
     * returns placement
     *
     * @return {Object}
     */
    getPlacement() {
      // return placement
      return (this.eden.get('placements') || {})[opts.placement] ? this.eden.get('placements')[opts.placement] : {
        'position' : opts.placement
      };
    }

  </script>
</cms-placement>
