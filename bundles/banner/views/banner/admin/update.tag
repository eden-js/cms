<banner-admin-update-page>
  <div class="page page-banner">
  
    <admin-header title="{ opts.item.id ? 'Update' : 'Create '} Banner">
      <yield to="right">
        <a href="/admin/banner" class="btn btn-lg btn-primary">
          Back
        </a>
      </yield>
    </admin-header>
    
    <div class="container-fluid">

      <form method="post" ref="form" action="/admin/banner/{ opts.item.id ? (opts.item.id + '/update') : 'create' }" class="admin-form">
        <div class="card mb-3">
          <div class="card-header">
            Banner Information
          </div>
          <div class="card-header">
            <ul class="nav nav-tabs card-header-tabs">
              <li each={ lng, i in this.languages } class="nav-item">
                <a class={ 'nav-link' : true, 'active' : this.language === lng } href="#!" data-lng={ lng } onclick={ onLanguage }>{ lng }</a>
              </li>
            </ul>
          </div>
          <div class="card-body">
            <upload name="image" multi={ false } image={ banner().image } />
            <div class="form-group">
              <label for="title">Banner Title</label>
              <input type="text" id="title" name="title[{ lng }]" class="form-control" value={ (banner().title || {})[lng] } hide={ this.language !== lng } each={ lng, i in this.languages } onchange={ onSlug }>
            </div>
            <div class="form-group">
              <label for="category">Banner Category</label>
              <input type="text" id="category" name="category" class="form-control" value={ banner().category }>
            </div>
            <div class="form-group">
              <editor label="Content" content={ (parent.banner().content || {})[lng] } each={ lng, i in this.languages } hide={ this.language !== lng } name="content[{ lng }]" />
            </div>
          </div>
          <div class="card-footer">
            <button class="btn btn-success" type="submit">
              <i class="fa fa-save" /> Save
            </button>
          </div>
        </div>
      </form>
    
    </div>
  </div>

  <script>
    // do mixin
    this.mixin('i18n');

    // set variables
    this.language  = this.i18n.lang();
    this.languages = this.eden.get('i18n').lngs || [];

    // check has language
    if (this.languages.indexOf(this.i18n.lang()) === -1) this.languages.unshift(this.i18n.lang());

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
     * get category
     *
     * @return {Object}
     */
    banner () {
      // return category
      return opts.item;
    }

    /**
     * on language update function
     */
    this.on('update', () => {
      // set language
      this.language = this.i18n.lang();

    });

  </script>
</banner-admin-update-page>
