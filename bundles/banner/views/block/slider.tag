<block-slider>
  <block on-refresh={ opts.onRefresh } on-save={ opts.onSave } on-remove={ opts.onRemove } block={ opts.block } data={ opts.data } on-update-title={ onUpdateTitle } on-complete-update-title={ onCompleteUpdateTitle } on-should-update-title={ onShouldUpdateTitle } on-update-interval={ onUpdateInterval } on-update-category={ onUpdateCategory } on-update-show={ onUpdateShow } ref="block" class="block-slider">
    <yield to="header">
      
      <!-- update buttons -->
      <a href="#!" onclick={ opts.onShouldUpdateTitle } if={ !this.updating.title && !this.loading.title }>
        <i class="fa fa-update fa-pencil" />
      </a>
      <a href="#!" onclick={ opts.onCompleteUpdateTitle } if={ this.updating.title && !this.loading.title }>
        <i class="fa fa-update fa-check bg-success text-white" />
      </a>
      <span if={ this.loading.title }>
        <i class="fa fa-update fa-spinner fa-spin bg-info text-white" />
      </span>
      <!-- / update buttons -->

      <i if={ !opts.data.title && !this.updating.title }>Untitled Slider</i>
      <span if={ !this.updating.title || this.loading.title }>{ opts.data.title }</span>
      <i contenteditable={ this.updating.title } if={ this.updating.title && !this.loading.title } class="d-inline-block px-2" ref="name" onkeyup={ opts.onUpdateTitle }>{ opts.data.title }</i>

    </yield>
    <yield to="body">
      <div class="card-body">
        <div class="form-group">
          <label>Category</label>
          <input class="form-control" name="category" onchange={ opts.onUpdateCategory } value={ opts.data.category } />
        </div>
        <div class="form-group">
          <label>Interval</label>
          <input class="form-control" name="interval" onchange={ opts.onUpdateInterval } value={ opts.data.interval } />
        </div>
        <div class="form-group">
          <label>Show Buttons</label>
          <select class="form-control" onchange={ opts.onUpdateShow } name="buttons">
            <option value="true" selected={ (opts.data.show || {}).buttons }>Yes</option>
            <option value="false" selected={ !(opts.data.show || {}).buttons }>No</option>
          </select>
        </div>
        <div class="form-group">
          <label>Show Indicators</label>
          <select class="form-control" onchange={ opts.onUpdateShow } name="indicators">
            <option value="true" selected={ (opts.data.show || {}).indicators }>Yes</option>
            <option value="false" selected={ !(opts.data.show || {}).indicators }>No</option>
          </select>
        </div>
        <div class="form-group">
          <label>Show Background</label>
          <select class="form-control" onchange={ opts.onUpdateShow } name="background">
            <option value="true" selected={ (opts.data.show || {}).background }>Yes</option>
            <option value="false" selected={ !(opts.data.show || {}).background }>No</option>
          </select>
        </div>
        <div class="form-group">
          <label>Show Caption</label>
          <select class="form-control" onchange={ opts.onUpdateShow } name="caption">
            <option value="true" selected={ (opts.data.show || {}).caption }>Yes</option>
            <option value="false" selected={ !(opts.data.show || {}).caption }>No</option>
          </select>
        </div>
      </div>
    </yield>
  </block>

  <script>

    /**
     * on update name
     *
     * @param  {Event} e
     */
    onUpdateTitle (e) {
      // on enter
      let keycode = (event.keyCode ? event.keyCode : event.which);

      // check if enter
      if (parseInt(keycode) === 13) {
        // return on complete update
        return this.onCompleteUpdateTitle(e);
      }

      // set update
      opts.data.title = jQuery(e.target).val();
    }

    /**
     * on update name
     *
     * @param  {Event} e
     */
    async onCompleteUpdateTitle (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set update
      this.refs.block.loading.title = true;
      this.refs.block.updating.title = false;

      // set name
      opts.data.title = jQuery('[ref="name"]', this.root).text();

      // update
      this.refs.block.update();

      // do update
      await opts.onSave(opts.block, opts.data);

      // set loading
      this.refs.block.loading.title = false;

      // update
      this.refs.block.update();
    }

    /**
     * on update category
     *
     * @param  {Event} e
     */
    async onUpdateCategory (e) {
      // set name
      opts.data.category = e.target.value;

      // do update
      await opts.onSave(opts.block, opts.data);
    }

    /**
     * on update category
     *
     * @param  {Event} e
     */
    async onUpdateInterval (e) {
      // set name
      opts.data.interval = parseInt(e.target.value);

      // do update
      await opts.onSave(opts.block, opts.data);
    }

    /**
     * on update category
     *
     * @param  {Event} e
     */
    async onUpdateShow (e) {
      // set name
      opts.data.show = opts.data.show || {};
        
      // set show name
      opts.data.show[jQuery(e.target).attr('name')] = jQuery(e.target).val() === 'true';

      // do update
      await opts.onSave(opts.block, opts.data);
    }

    /**
     * on update name
     *
     * @param  {Event} e
     */
    onShouldUpdateTitle (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set update
      this.refs.block.updating.title = !this.refs.block.updating.title;

      // update
      this.refs.block.update();

      // set inner test
      jQuery('[ref="name"]', this.root).focus();
    }

  </script>
</block-slider>
