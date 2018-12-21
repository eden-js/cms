<block-container>
  <block ref="block" class="block-container-inner" on-container-class={ onContainerClass } get-blocks={ getBlocks } get-element={ getElement }>
    <yield to="body">
      <span class="eden-dropzone-label" if={ this.acl.validate('admin') && !opts.preview }>
        Container #{ opts.placement }
      </span>
      <eden-add type="top" onclick={ opts.onAddBlock } way="unshift" placement={ opts.placement + '.children' } if={ this.acl.validate('admin') && !opts.preview } />
      
      <div class="{ opts.block.container || 'container' } { this.acl.validate('admin') && !opts.preview ? 'eden-dropzone' : '' } { 'empty' : !opts.getBlocks(opts.block.children).length }" data-placement={ opts.placement + '.children' }>
        <div if={ !opts.getBlocks(opts.block.children).length } class="py-5 text-center">Add Elements</div>
        <div each={ child, a in opts.getBlocks(opts.block.children) } no-reorder class={ child.class } data-is={ opts.getElement(child) } preview={ opts.preview } data-block={ child.uuid } data={ opts.getBlock(child) } block={ child } get-block={ opts.getBlock } on-add-block={ opts.onAddBlock } on-save={ opts.onSave } on-remove={ opts.onRemove } on-refresh={ opts.onRefresh } i={ a } placement={ opts.placement + '.children.' + a } />
      </div>
      
      <eden-add type="bottom" onclick={ opts.onAddBlock } way="push" placement={ opts.placement + '.children' } if={ this.acl.validate('admin') && !opts.preview } />
      <span class="eden-dropzone-label eden-dropzone-label-end" if={ this.acl.validate('admin') && !opts.preview }>
        Container #{ opts.placement } End
      </span>
    </yield>
    
    <yield to="modal">
      <div class="form-group">
        <label>
          Container Class
        </label>
        <input class="form-control" ref="container" value={ opts.block.container || 'container' } onchange={ opts.onContainerClass } />
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
    async onContainerClass (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.block.container = e.target.value.length ? e.target.value : null;

      // run opts
      if (opts.onSave) await opts.onSave(opts.block, opts.data, opts.placement);
    }
    
  </script>
</block-container>
