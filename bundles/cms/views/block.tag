<block>
  <div class={ 'eden-block' : true, 'eden-block-admin' : this.acl.validate('admin') && !opts.preview } data-block={ opts.block.uuid } id="block-{ opts.block.uuid }">

    <div class="eden-block-hover{ opts.isContainer ? ' eden-block-hover-dropzone' : '' }" if={ this.acl.validate('admin') && !opts.preview }>
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
              <button class="btn btn-sm btn-secondary" onclick={ onUpdateSidebar }>
                <i class="fa fa-pencil-alt" />
              </button>
              <button class="btn btn-sm btn-secondary" onclick={ onRemoveSidebar }>
                <i class={ 'fa fa-times' : true, 'fa-spin' : this.removing || opts.block.removing } />
              </button>
              <span class="btn btn-sm btn-secondary move" for={ opts.block.uuid }>
                <i class="fa fa-arrows-alt" />
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <yield from="body" />
  </div>

  <div class="eden-blocks-backdrop" if={ this.showing } onclick={ ohHideSidebar } />

  <div class={ 'eden-blocks-sidebar' : true, 'eden-blocks-sidebar-show' : this.sidebar.update } ref="update" if={ this.showing && this.acl.validate('admin') && !opts.preview }>
    <div class="card">
      <div class="card-header">
        <h5 class="m-0">
          Update Block
        </h5>
      </div>
      <div class="card-body">
        <div class="form-group">
          <label>
            Block Class
          </label>
          <input class="form-control" ref="class" value={ opts.block.class } onchange={ onClass } />
        </div>
        <yield from="modal" />
        <yield from="options" />
      </div>
      <div class="card-footer">
        <button class={ 'btn btn-secondary float-right' : true, 'disabled' : this.removing } onclick={ ohHideSidebar }>
          Close
        </button>
      </div>
    </div>
  </div>

  <div class={ 'eden-blocks-sidebar' : true, 'eden-blocks-sidebar-show' : this.sidebar.remove } ref="remove" if={ this.showing && this.acl.validate('admin') && !opts.preview }>
    <div class="card">
      <div class="card-header">
        <h5 class="m-0">
          Remove Block
        </h5>
      </div>
      <div class="card-body">
        Are you sure you want to remove this block?
      </div>
      <div class="card-footer">
        <button class={ 'btn btn-danger' : true, 'disabled' : this.removing } onclick={ onRemove } disabled={ this.removing }>
          { this.removing ? 'Removing...' : 'Remove' }
        </button>
        <button class={ 'btn btn-secondary float-right' : true, 'disabled' : this.removing } onclick={ ohHideSidebar }>
          Close
        </button>
      </div>
    </div>
  </div>

  <script>
    // do mixins
    this.mixin('acl');
    this.mixin('block');

    // set variables
    this.sidebar = {};

    /**
     * on update modal

     * @param  {Event} e
     */
    onUpdateSidebar (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      this.showing = true;
      
      // set editing
      if (opts.onEditing) opts.onEditing(opts.block);

      // update view
      this.update();
      this.sidebar.update = true;
      this.sidebar.remove = false;

      // update view
      this.update();
    }

    /**
     * on remove modal

     * @param  {Event} e
     */
    onRemoveSidebar (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      this.showing = true;

      // update view
      this.update();
      this.sidebar.remove = true;
      this.sidebar.update = false;

      // update view
      this.update();
    }

    /**
     * on remove modal

     * @param  {Event} e
     */
    ohHideSidebar(e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      this.showing = false;

      // update view
      this.update();
      this.sidebar.update = false;
      this.sidebar.remove = false;

      // update view
      this.update();
    }

    /**
     * on class

     * @param  {Event} e
     */
    async onClass (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.block.class = e.target.value.length ? e.target.value : null;

      // run opts
      if (opts.onSave) await opts.onSave(opts.block, opts.data, opts.placement);
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

      // run opts
      if (opts.onRemove) await opts.onRemove(opts.block, opts.data, opts.placement);

      // set refreshing
      this.removing = false;

      // update view
      this.update();
    }

    // on unmount function
    this.on('unmount', () => {
      // check frontend
      if (!this.eden.frontend) return;

      // remove modal backdrops
      jQuery('.modal-backdrop').remove();
    });

    // on update
    this.on('update', () => {
      // check frontend
      if (!this.eden.frontend) return;

      // remove editing
      if (!this.showing && !this.sidebar.update && (opts.editing === opts.block.uuid)) {
        // set editing
        opts.block.editing = false;

        // set false
        if (opts.onEditing) opts.onEditing(false);
      }
    });

    // on unmount function
    this.on('mount', () => {
      // check frontend
      if (!this.eden.frontend || opts.preview) return;

      // remove modal backdrops
      if (opts.editing === opts.block.uuid) {
        // set update
        this.sidebar.update = true;
  
        // update view
        this.update();
        
        // show modal immediately
        jQuery(this.refs.update).removeClass('fade').modal('show').addClass('fade');
      }
    });
  </script>
</block>
