<block-admin-update-page>
  <div class="page page-block">
    <!-- page header -->
    <div class="mb-4 hidden-sm-down">
      <h1 class="page-title h3 mb-0 text-center text-md-left text-uppercase">
        <i class="if-icon-serials mr-3"></i> { opts.item.id ? 'Update' : 'Create '} Block
      </h1>
    </div>
    <!-- / page header -->

    <form method="post" ref="form" action="/admin/block/{ opts.item.id ? (opts.item.id + '/update') : 'create' }" class="admin-form">
      <input if={ opts.redirect } name="redirect" value={ opts.redirect } type="hidden" />
      <div class="card mb-3">
        <div class="card-header">
          Block Information
        </div>
        <div class="card-header">
          <ul class="nav nav-tabs card-header-tabs">
            <li each={ lng, i in this.languages } class="nav-item">
              <a class={ 'nav-link' : true, 'active' : this.language === lng } href="#!" data-lng={ lng } onclick={ onLanguage }>{ lng }</a>
            </li>
          </ul>
        </div>
        <div class="card-body">
          <div class="form-group">
            <label for="placement">Block Placement</label>
            <input type="text" id="placement" name="placement" class="form-control" value={ block().placement || opts.placement }>
          </div>
          <div class="form-group">
            <label for="title">Block Title</label>
            <input type="text" class="form-control" value={ (block ().title || {})[lng] } each={ lng, i in this.languages } hide={ this.language !== lng } name="title[{ lng }]">
          </div>
          <div class="form-group">
            <label for="priority">Block Priority</label>
            <input type="number" class="form-control" value={ block ().priority } name="priority">
          </div>
          <div class="form-group">
            <label for="placement">Block Type</label>
            <select class="form-control" name="type" onchange={ onType }>
              <option value="html" selected={ this.type === 'html' }>
                HTML
              </option>
            </select>
          </div>
          <div class="form-group">
            <label for="placement">Block</label>
            <editor content={ (block ().content || {})[lng] } each={ lng, i in this.languages } hide={ this.language !== lng } name="content[{ lng }]" />
          </div>
        </div>

        <!-- article submission -->
        <div class="card-footer text-right">
          <button class="btn btn-success" type="submit">
            <i class="fa fa-save" /> Save
          </button>
        </div>
        <!-- / article submission -->
      </div>
    </form>
  </div>

  <script>
    // do mixin
    this.mixin ('i18n');

    // load data
    this.type      = opts.item.type || 'html';
    this.language  = this.i18n.lang ();
    this.languages = this.eden.get ('i18n').lngs || [];

    // check has language
    if (this.languages.indexOf (this.i18n.lang ()) === -1) this.languages.unshift (this.i18n.lang ());

    /**
     * on language
     *
     * @param  {Event} e
     */
    onLanguage (e) {
      // set language
      this.language = e.target.getAttribute ('data-lng');

      // update view
      this.update ();
    }

    /**
     * on language
     *
     * @param  {Event} e
     */
    onType (e) {
      // set language
      this.type = e.target.value;

      // update view
      this.update ();
    }

    /**
     * get category
     *
     * @return {Object}
     */
    block () {
      // return category
      return opts.item;
    }

    /**
     * on language update function
     */
    this.on ('update', () => {
      // set language
      this.language = this.i18n.lang ();
    });

  </script>
</block-admin-update-page>
