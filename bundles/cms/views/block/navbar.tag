<block-navbar>
  <block on-refresh={ opts.onRefresh } chart={ this.chart } options={ this.options } placement={ opts.placement } preview={ opts.preview } on-navbar-class={ onNavbarClass } on-navbar-container-class={ onNavbarContainerClass } on-add-block={ opts.onAddBlock } get-blocks={ getBlocks } get-element={ getElement } get-block={ opts.getBlock } on-save={ opts.onSave } on-remove={ opts.onRemove } size={ this.size } block={ opts.block } data={ opts.data } on-color={ onColor } ref="block" class="block-container-inner">
    <yield to="body">
      <span class="eden-dropzone-label" if={ this.acl.validate('admin') && !opts.preview }>
        Navbar #{ opts.placement }
      </span>
      
      <nav class={ opts.block.navbar || 'navbar navbar-expand-lg navbar-light bg-light' }>
        <div class={ opts.block.container || 'container' }>
          <div class={ 'navbar-brand' : true, 'eden-dropzone' : this.acl.validate('admin') && !opts.preview }>
            <eden-add type="top" onclick={ opts.onAddBlock } way="unshift" placement={ opts.placement + '.left' } if={ this.acl.validate('admin') && !opts.preview } />
            
            <div if={ !opts.getBlocks(opts.block.left).length } class="text-center">Add Elements</div>
            <div each={ child, a in opts.getBlocks(opts.block.left) } no-reorder class={ child.class } data-is={ opts.getElement(child) } preview={ opts.preview } data-block={ child.uuid } data={ opts.getBlock(child) } block={ child } get-block={ opts.getBlock } on-add-block={ opts.onAddBlock } on-save={ opts.onSave } on-remove={ opts.onRemove } on-refresh={ opts.onRefresh } i={ a } placement={ opts.placement + '.left.' + a } />
            
            <eden-add type="bottom" onclick={ opts.onAddBlock } way="push" placement={ opts.placement + '.left' } if={ this.acl.validate('admin') && !opts.preview } />
          </div>
          
          <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#{ opts.block.uuid }" aria-controls={ opts.block.uuid } aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>

          <div class={ 'collapse navbar-collapse' : true, 'eden-dropzone' : this.acl.validate('admin') && !opts.preview } id={ opts.block.uuid }>
            <eden-add type="top" onclick={ opts.onAddBlock } way="unshift" placement={ opts.placement + '.right' } if={ this.acl.validate('admin') && !opts.preview } />
            
            <div if={ !opts.getBlocks(opts.block.right).length } class="text-center">Add Elements</div>
            <div each={ child, a in opts.getBlocks(opts.block.right) } no-reorder class={ child.class } data-is={ opts.getElement(child) } preview={ opts.preview } data-block={ child.uuid } data={ opts.getBlock(child) } block={ child } get-block={ opts.getBlock } on-add-block={ opts.onAddBlock } on-save={ opts.onSave } on-remove={ opts.onRemove } on-refresh={ opts.onRefresh } i={ a } placement={ opts.placement + '.right.' + a } />
            
            <eden-add type="bottom" onclick={ opts.onAddBlock } way="push" placement={ opts.placement + '.right' } if={ this.acl.validate('admin') && !opts.preview } />
          </div>
        </div>
      </nav>
      
      <span class="eden-dropzone-label eden-dropzone-label-end" if={ this.acl.validate('admin') && !opts.preview }>
        Navbar #{ opts.placement } End
      </span>
    </yield>
    
    <yield to="modal">
      <div class="form-group">
        <label>
          Navbar Class
        </label>
        <input class="form-control" ref="navbar" value={ opts.block.navbar || 'navbar navbar-expand-lg navbar-light bg-light' } onchange={ opts.onNavbarClass } />
      </div>
      <div class="form-group">
        <label>
          Navbar Container Class
        </label>
        <input class="form-control" ref="container" value={ opts.block.container || 'container' } onchange={ opts.onNavbarContainerClass } />
      </div>
    </yield>
  </block>
  
  <script>
    // do mixins
    this.mixin('acl');
    
    // set value
    if (!opts.block.left) opts.block.left = [];
    if (!opts.block.right) opts.block.right = [];
    
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
    async onNavbarClass (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.block.navbar = e.target.value.length ? e.target.value : null;

      // run opts
      if (opts.onSave) await opts.onSave(opts.block, opts.data, opts.placement);
    }

    /**
     * on class

     * @param  {Event} e
     */
    async onNavbarContainerClass (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.block.container = e.target.value.length ? e.target.value : null;

      // run opts
      if (opts.onSave) await opts.onSave(opts.block, opts.data, opts.placement);
    }
    
  </script>
</block-navbar>
