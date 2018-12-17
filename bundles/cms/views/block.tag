<block>
  <div class={ 'eden-block' : true, 'eden-block-admin' : this.acl.validate('admin') && !opts.preview } id="block-{ opts.block.uuid }">

    <div class="eden-block-hover" if={ this.acl.validate('admin') && !opts.preview }>
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
              <button class="btn btn-sm btn-secondary" onclick={ onRefresh }>
                <i class={ 'fa fa-sync' : true, 'fa-spin' : this.refreshing || opts.block.refreshing } />
              </button>
              <button class="btn btn-sm btn-secondary" onclick={ onShowModal }>
                <i class="fa fa-pencil" />
              </button>
              <button class="btn btn-sm btn-secondary" onclick={ onRemove }>
                <i class={ 'fa fa-times' : true, 'fa-spin' : this.removing || opts.block.removing } />
              </button>
              <span class="btn btn-sm btn-secondary move">
                <i class="fa fa-arrows" />
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <yield from="body" />
  </div>

  <div class="modal fade" id="block-{ opts.block.uuid }-update" tabindex="-1" role="dialog" aria-labelledby="block-{ opts.block.uuid }-label" aria-hidden="true" if={ this.showModal && this.acl.validate('admin') && !opts.preview }>
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
            <input class="form-control" ref="class" value={ opts.block.class } onchange={ onClass } />
          </div>
          <yield from="modal" />
        </div>
      </div>
    </div>
  </div>

  <script>
    // do mixins
    this.mixin('acl');

    // set variables
    this.loading = {};
    this.updating = {};
    this.showModal = false;

    /**
     * on class

     * @param  {Event} e
     */
    async onShowModal (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      this.showModal = true;
      
      // update view
      this.update();

      // run opts
      jQuery('#block-' + opts.block.uuid + '-update').modal('show');
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
      this.parent.opts.block.class = e.target.value.length ? e.target.value : null;

      // run opts
      if (opts.onSave) await opts.onSave(this.parent.opts.block, this.parent.opts.data, this.parent.opts.placement);
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
      if (opts.onRefresh) await opts.onRefresh(this.parent.opts.block, this.parent.opts.data, this.parent.opts.placement);

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

      // run opts
      if (opts.onRemove) await opts.onRemove(this.parent.opts.block, this.parent.opts.data, this.parent.opts.placement);

      // set refreshing
      this.removing = false;

      // update view
      this.update();
    }

  </script>
</block>
