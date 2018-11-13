<page-admin-update-page>
  <div class="page page-page">
  
    <admin-header title="{ opts.item.id ? 'Update' : 'Create'} Page">
      <yield to="right">
        <a href="/admin/page" class="btn btn-lg btn-primary">
          Back
        </a>
      </yield>
    </admin-header>
    
    <div class="container-fluid">

      <form method="post" ref="form" action="/admin/page/{ opts.item.id ? (opts.item.id + '/update') : 'create' }" class="admin-form">
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
              <input type="text" id="title" name="title[{ lng }]" class="form-control" value={ (page ().title || {})[lng] } hide={ this.language !== lng } each={ lng, i in this.languages } onchange={ onSlug }>
            </div>
            <div class="form-group">
              <label for="slug">Page Slug</label>
              <input type="text" id="slug" name="slug" class="form-control" ref="slug" value={ page ().slug }>
            </div>
            <div class="form-group">
              <label for="placement">Content</label>
              <editor each={ lng, i in this.languages } hide={ this.language !== lng } name="content[{ lng }]" content={ (page ().content || {})[lng] } />
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
  </div>

  <script>
    // do mixin
    this.mixin ('i18n');

    // load data
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
     * set slug
     *
     * @param  {Event} e
     */
    onSlug (e) {
      // require slug
      let slug = require ('slug');

      // set slug
      this.refs.slug.value = slug (e.target.value).toLowerCase ();
    }

    /**
     * get category
     *
     * @return {Object}
     */
    page () {
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
</page-admin-update-page>
