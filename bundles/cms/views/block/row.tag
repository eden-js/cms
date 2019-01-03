<block-row>
  <block ref="block" class="block-row-inner" on-row-class={ onRowClass } on-center-vertically={ onCenterVertically } get-blocks={ getBlocks } get-element={ getElement }>
    <yield to="body">
      <span class="eden-dropzone-label" if={ this.acl.validate('admin') && !opts.preview }>
        Row #{ opts.placement }
      </span>
      <eden-add type="top" onclick={ opts.onAddBlock } way="unshift" placement={ opts.placement + '.children' } if={ this.acl.validate('admin') && !opts.preview } />
      
      <div class="{ opts.block.row || 'row row-eq-height' } { this.acl.validate('admin') && !opts.preview ? 'eden-dropzone' : '' } { 'empty' : !opts.getBlocks(opts.block.children).length }" data-placement={ opts.placement + '.children' }>
        <div if={ !opts.getBlocks(opts.block.children).length } class="col py-5 text-center">Add Elements</div>
        <div if={ opts.block.centerVertically } each={ child, a in opts.getBlocks(opts.block.children) } no-reorder class="{ child.class || 'col' } d-flex align-items-center" data-block={ child.uuid } placement={ opts.placement + '.children.' + a }>
          <div data-is={ opts.getElement(child) } class="w-100" preview={ opts.preview } data={ opts.getBlock(child) } block={ child } get-block={ opts.getBlock } on-add-block={ opts.onAddBlock } on-save={ opts.onSave } on-remove={ opts.onRemove } on-refresh={ opts.onRefresh } i={ a } placement={ opts.placement + '.children.' + a } />
        </div>
        <div if={ !opts.block.centerVertically } each={ child, a in opts.getBlocks(opts.block.children) } no-reorder class={ child.class || 'col' } data-is={ opts.getElement(child) } preview={ opts.preview } data-block={ child.uuid } data={ opts.getBlock(child) } block={ child } get-block={ opts.getBlock } on-add-block={ opts.onAddBlock } on-save={ opts.onSave } on-remove={ opts.onRemove } on-refresh={ opts.onRefresh } i={ a } placement={ opts.placement + '.children.' + a } />
      </div>
      
      <eden-add type="bottom" onclick={ opts.onAddBlock } way="push" placement={ opts.placement + '.children' } if={ this.acl.validate('admin') && !opts.preview } />
      <span class="eden-dropzone-label eden-dropzone-label-end" if={ this.acl.validate('admin') && !opts.preview }>
        Row #{ opts.placement } End
      </span>
    </yield>
    
    <yield to="modal">
      <div class="form-group">
        <label>
          Row Class
        </label>
        <input class="form-control" ref="row" value={ opts.block.row || 'row' } onchange={ opts.onRowClass } />
      </div>
      <div class="form-group">
        <label>
          Center Vertically
        </label>
        <select class="form-control" ref="center" onchange={ opts.onCenterVertically }>
          <option value="true" selected={ opts.block.centerVertically }>Yes</option>
          <option value="false" selected={ !opts.block.centerVertically }>No</option>
        </select>
      </div>
    </yield>
  </block>
  
  <script>
    // do mixins
    this.mixin('acl');
    
    // set value
    if (!opts.block.children) opts.block.children = [];
    
    /**
     * get blocks
     *
     * @param  {Array} blocks
     *
     * @return {Array}
     */
    getBlocks (blocks) {
      // return filtered blocks
      return (blocks || []).filter((child) => child);
    }
    
    /**
     * get element
     *
     * @param  {Object} child
     *
     * @return {*}
     */
    getElement (child) {
      // return get child
      return (opts.getBlock(child) || {}).tag ? 'block-' + (opts.getBlock(child) || {}).tag : 'eden-loading';
    }

    /**
     * on class

     * @param  {Event} e
     */
    async onRowClass (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.block.row = e.target.value.length ? e.target.value : null;

      // run opts
      if (opts.onSave) await opts.onSave(opts.block, opts.data, opts.placement);
    }
    
    /**
     * center vertically
     *
     * @param  {Event}  e
     *
     * @return {Promise}
     */
    async onCenterVertically (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.block.centerVertically = jQuery(e.target).val() === 'true';

      // run opts
      if (opts.onSave) await opts.onSave(opts.block, opts.data, opts.placement);
    }
    
  </script>
</block-row>
