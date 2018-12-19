<page-admin-update-page>
  <admin-header title="{ this.page.get('id') ? 'Update' : 'Create' } Page { this.page.get('title.' + this.language) }" on-preview={ onPreview }>
    <yield to="right">

      <a href="/admin/page" class="btn btn-lg btn-primary">
        Back
      </a>

    </yield>
  </admin-header>

  <div class="container-fluid">

    <div ref="form" class="admin-form" show={ !this.preview }>
      <div class="card mb-3">
        <div class="card-header">
          Page Information
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
            <label for="title">Page Title</label>
            <input type="text" id="title" name="title[{ lng }]" class="form-control" value={ (page.get('title') || {})[lng] } data-input="title.{ lng }" hide={ this.language !== lng } each={ lng, i in this.languages } onchange={ onSlug }>
          </div>
          <div class="form-group">
            <label for="slug">Page Slug</label>
            <input type="text" id="slug" name="slug" class="form-control" ref="slug" data-input="slug" value={ page.get('slug') } onchange={ onInput }>
          </div>
          <div class="form-group">
            <label for="layout">Page Layout</label>
            <input type="text" id="layout" name="layout" class="form-control" ref="layout" data-input="layout" value={ page.get('layout') } onchange={ onInput }>
          </div>
        </div>

      </div>
    </div>

    <div class="cms-placement-blocks" data-placement={ (opts.item || {}).id || 'page' } data-is="eden-blocks" placement={ this.page.get('placement') || {} } for="frontend" blocks={ opts.blocks } on-save={ onPlacement } position={ (opts.item || {}).id || 'page' } />

  </div>

  <script>
    // do mixins
    this.mixin('i18n');
    this.mixin('model');

    // set update
    this.type     = opts.type;
    this.page     = this.model('page', opts.item);
    this.loading  = {};
    this.updating = {};

    // load data
    this.language  = this.i18n.lang();
    this.languages = this.eden.get('i18n').lngs || [];

    // check has language
    if (this.languages.indexOf(this.i18n.lang()) === -1) this.languages.unshift(this.i18n.lang());

    /**
     * set placement
     *
     * @param  {Placement} placement
     */
    async onPlacement (placement) {
      // check id
      if (placement.get('id') !== (this.page.get('placement') || {}).id) {
        // update placement
        this.page.set('placement', placement.get());

        // save
        await this.savePage(this.page);
      }
    }

    /**
     * on preview
     *
     * @param  {Event} e
     */
    onInput (e) {
      // save page
      this.savePage(this.page);
    }

    /**
     * on language
     *
     * @param  {Event} e
     */
    onLanguage (e) {
      // set language
      this.language = e.target.getAttribute('data-lng');

      // update view
      this.update();
    }

    /**
     * set slug
     *
     * @param  {Event} e
     */
    onSlug (e) {
      // require slug
      let slug = require('slug');

      // set slug
      this.refs.slug.value = slug(e.target.value).toLowerCase();

      // save page
      this.savePage(this.page);
    }

    /**
     * saves page
     *
     * @param  {Object}  page
     *
     * @return {Promise}
     */
    async savePage (page) {
      // set loading
      this.loading.save = true;

      // update view
      this.update();

      // check type
      if (!page.type) page.set('type', opts.type);

      // set input values
      jQuery('[data-input]', this.refs.form).each((i, elem) => {
        // set value
        page.set(jQuery(elem).attr('data-input'), jQuery(elem).val());
      });

      // log data
      let res = await fetch('/admin/page/' + (page.get('id') ? page.get('id') + '/update' : 'create'), {
        'body'    : JSON.stringify(this.page.get()),
        'method'  : 'post',
        'headers' : {
          'Content-Type' : 'application/json'
        },
        'credentials' : 'same-origin'
      });

      // load data
      let data = await res.json();
      
      // check if new page
      if (!page.get('id') && data.result.id) {
        // change url
        let state = Object.assign({}, {
          'prevent' : true
        }, eden.router.history.location.state);
        
        // replace state
        eden.router.history.replace({
          'state'    : state,
          'pathname' : '/admin/page/' + data.result.id + '/update'
        });
      }

      // set logic
      for (let key in data.result) {
        // clone to page
        page.set(key, data.result[key]);
      }

      // set loading
      this.loading.save = false;

      // update view
      this.update();
    }


    /**
     * on update
     *
     * @type {update}
     */
    this.on('update', () => {
      // check frontend
      if (!this.eden.frontend) return;

      // set language
      this.language = this.i18n.lang();

    });

    /**
     * on mount
     *
     * @type {mount}
     */
    this.on('mount', () => {
      // check frontend
      if (!this.eden.frontend) return;

      // set page
      this.page = this.model('page', opts.item);
      
      // set to placements
      if (this.page.id) this.eden.set('placements.' + this.page.id, this.page.get('placement'));

    });
  </script>
</page-admin-update-page>
