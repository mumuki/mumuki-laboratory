var mumuki = mumuki || {};

(function (mumuki) {
    function createAceEditors() {
        var editors = $(".editor").map(function (index, textarea) {
            var $textarea = $(textarea);
            var builder = new mumuki.editor.AceEditorBuilder(textarea);
            builder.setupEditor();
            builder.setupOptions($textarea.data('lines'));
            builder.setupPlaceholder($textarea.data('placeholder'));
            builder.setupSubmit();
            builder.setupLanguage();
            return builder.build();
        });

        if (editors[0]) {
            if (!$('#solution_editor_bottom').val())
                editors[0].focus();
        }
        return editors;
    }

    function onSelectUpdateAceEditor() {
        $("#exercise_language_id").change(updateAceEditorLanguage);
    }

    function resetEditor() {
        mumuki.page.dynamicEditors.forEach(function (e) {
            setDefaultContent(e, $('#default_content').val());
        })
    }

    function setDefaultContent(editor, content) {
        editor.setValue(content, 1);
    }

    function updateAceEditorLanguage() {
        var language = $("#exercise_language_id").find(":selected").html() || $('#exercise_language').val();
        if (language !== undefined) {
            mumuki.page.dynamicEditors.forEach(function (e) {
                setEditorLanguage(e, language);
            })
        }
    }

    function setEditorLanguage(editor, language) {
        editor.getSession().setMode("ace/mode/" + language.toLowerCase())
    }

    mumuki.editor = mumuki.editor || {};
    mumuki.editor.setupAceEditors = setEditorLanguage;

    mumuki.page = mumuki.page || {};
    mumuki.page.dynamicEditors = [];
    mumuki.page.editors = [];

    function startAceEditor() {
        mumuki.page.editors = createAceEditors();
        updateAceEditorLanguage();
        onSelectUpdateAceEditor();

        $('.editor-reset').click(function () {
            resetEditor();
        });
    }

    mumukiLoad(startAceEditor);

}(mumuki));
